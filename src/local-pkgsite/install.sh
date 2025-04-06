#!/usr/bin/env bash
set -e

PORT=${PORT:-6060}
RELOAD_DELAY=${RELOAD_DELAY:-2000}
RELOAD_DEBOUNCE=${RELOAD_DEBOUNCE:-5000}

PKGSITE_SERVE_PATH="/usr/local/bin/pkgsite-serve"

echo "Activating feature 'local-pkgsite'..."

# --- distribution detection and package management
. /etc/os-release
if [ "${ID}" = "debian" ] || [ "${ID_LIKE}" = "debian" ]; then
    ADJUSTED_ID="debian"
elif [ "${ID}" = "alpine" ]; then
    ADJUSTED_ID="alpine"
elif [[ "${ID}" = "rhel" || "${ID}" = "fedora" || "${ID}" = "mariner" || "${ID_LIKE}" = *"rhel"* || "${ID_LIKE}" = *"fedora"* || "${ID_LIKE}" = *"mariner"* ]]; then
    ADJUSTED_ID="rhel"
    VERSION_CODENAME="${ID}${VERSION_ID}"
else
    echo "Linux distro ${ID} not supported."
    exit 1
fi

if [ "${ADJUSTED_ID}" = "rhel" ] && [ "${VERSION_CODENAME-}" = "centos7" ]; then
    # As of 1 July 2024, mirrorlist.centos.org no longer exists.
    # Update the repo files to reference vault.centos.org.
    sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo
    sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo
    sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo
fi

if type apt-get > /dev/null 2>&1; then
    INSTALL_CMD=apt-get
elif type apk > /dev/null 2>&1; then
    INSTALL_CMD=apk
elif type microdnf > /dev/null 2>&1; then
    INSTALL_CMD=microdnf
elif type dnf > /dev/null 2>&1; then
    INSTALL_CMD=dnf
elif type yum > /dev/null 2>&1; then
    INSTALL_CMD=yum
else
    echo "(Error) Unable to find a supported package manager."
    exit 1
fi

clean_up() {
    case ${ADJUSTED_ID} in
        debian)
            rm -rf /var/lib/apt/lists/*
            ;;
        alpine)
            rm -rf /var/cache/apk/*
            ;;
        rhel)
            rm -rf /var/cache/dnf/*
            rm -rf /var/cache/yum/*
            ;;
    esac
}

pkg_mgr_update() {
    if [ ${INSTALL_CMD} = "apt-get" ]; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            echo "Running apt-get update..."
            ${INSTALL_CMD} update -y
        fi
    elif [ ${INSTALL_CMD} = "apk" ]; then
        if [ "$(find /var/cache/apk/* | wc -l)" = "0" ]; then
            echo "Running apk update..."
            ${INSTALL_CMD} update
        fi
    elif [ ${INSTALL_CMD} = "dnf" ] || [ ${INSTALL_CMD} = "yum" ]; then
        if [ "$(find /var/cache/${INSTALL_CMD}/* | wc -l)" = "0" ]; then
            echo "Running ${INSTALL_CMD} check-update ..."
            ${INSTALL_CMD} check-update
        fi
    fi
}

check_packages() {
    if [ ${INSTALL_CMD} = "apt-get" ]; then
        if ! dpkg -s "$@" > /dev/null 2>&1; then
            pkg_mgr_update
            ${INSTALL_CMD} -y install --no-install-recommends "$@"
        fi
    elif [ ${INSTALL_CMD} = "apk" ]; then
        ${INSTALL_CMD} add \
            --no-cache \
            "$@"
    elif [ ${INSTALL_CMD} = "dnf" ] || [ ${INSTALL_CMD} = "yum" ]; then
        _num_pkgs=$(echo "$@" | tr ' ' \\012 | wc -l)
        _num_installed=$(${INSTALL_CMD} -C list installed "$@" | sed '1,/^Installed/d' | wc -l)
        if [ ${_num_pkgs} != ${_num_installed} ]; then
            pkg_mgr_update
            ${INSTALL_CMD} -y install "$@"
        fi
    elif [ ${INSTALL_CMD} = "microdnf" ]; then
        ${INSTALL_CMD} -y install \
            --refresh \
            --best \
            --nodocs \
            --noplugins \
            --setopt=install_weak_deps=0 \
            "$@"
    else
        echo "Linux distro ${ID} not supported."
        exit 1
    fi
}

export DEBIAN_FRONTEND=noninteractive

# ---- install missing distro packages, where necessary
case ${ADJUSTED_ID} in
    debian)
        check_packages net-tools
        ;;
    rhel)
        check_packages net-tools
        ;;
esac

# ---- install Go pkgsite
mkdir -p /tmp/gotools
export GOCACHE=/tmp/gotools/cache

go install golang.org/x/pkgsite/cmd/pkgsite@latest

rm -rf /tmp/gotools

PKGSITE_BIN=$(which pkgsite)

# ---- install node browser-sync, nodemon 
npm -g install browser-sync
npm -g install nodemon

tee "${PKGSITE_SERVE_PATH}" > /dev/null \
<< EOF
#!/usr/bin/env sh

# we need to explicitly "activate" (the current) node here, as otherwise
# devcontainers using our feature and also setting their remoteEnv PATH will
# cause our script to fail when run as the postStartCommand. 
. /usr/local/share/nvm/nvm.sh
nvm use node

# Pick a random local IP port that is currently available. Since this isn't
# really an atomic operation it has a small chance to fail, but for the moment
# we have to live with this chance.
INT_PORT=$(comm -23 <(seq $(cat /proc/sys/net/ipv4/ip_local_port_range | tr ' ' '\n') | sort) \
    <(netstat -ntl | awk '/LISTEN/ {split($4,a,":"); print a[2]}' | sort -u) 2>/dev/null \
    | shuf | head -n 1)

wait_for_process_logfile() {
    local name=\$1
    local file=\$2
    local now=\$(date +%s)
    local end=\$((now + 5))
    while true; do
        if [ -s "\${file}" ]; then
            echo "...\${name} started"
            break
        fi
        now=\$(date +%s)
        if [ "\${now}" -ge "\${end}" ]; then
            echo "ERROR: \${name} did not start"
            break
        fi
        sleep 0.25
    done
}

# Start browser-sync in the background to proxy from the local pkgsite on a
# random/ephemeral HTTP port that the determined above to the "public" port
# where browser want to connect to.
BROWSYNC_LOGFILE=/tmp/nohup-local-pkgsite-browser-sync.log
setsid --fork bash -c "\
    browser-sync start \
        --port ${PORT} \
        --proxy localhost:\${INT_PORT} \
        --reload-delay ${RELOAD_DELAY} \
        --reload-debounce ${RELOAD_DEBOUNCE} \
        --no-ui \
        --no-open \
    >\${BROWSYNC_LOGFILE} 2>&1"
wait_for_process_logfile "browser-sync" \${BROWSYNC_LOGFILE}

# Monitor for any *.go or (heaven forbid) our go.mod to change, then first
# terminate the already running local pkgsite and restart it; as before, serve
# the local pkgsite on a random/ephemeral HTTP port that the determined above.
# Then trigger a reload in connected browsers. Please note that we run nodemon
# and it will then run "browser-sync reload" on demand, as well as pkgsite).
NODEM_LOGFILE=/tmp/nohup-local-pkgsite-nodemon.log
setsid --fork bash -c "\
    nodemon \
        --signal SIGTERM \
        --watch './**/*' \
        -e go \
        --watch 'go.mod' \
        --exec \"
            browser-sync --port ${PORT} reload \
            && ${PKGSITE_BIN} -http=localhost:\${INT_PORT} .
            \" \
    >\${NODEM_LOGFILE} 2>&1"
wait_for_process_logfile "nodemon" \${NODEM_LOGFILE}
EOF
chmod 0755 "${PKGSITE_SERVE_PATH}"

clean_up
