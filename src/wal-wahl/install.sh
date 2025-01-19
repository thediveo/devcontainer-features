#!/usr/bin/env bash

set -e
shopt -s nullglob

MOBY="false"

if [ ! -z "${VERSION}" ]; then
    echo "FATAL: \$VERSION set instead of \$VERSIONS"
    exit 1
fi

WHALE_SWITCH_BASE=/opt/wal-wahl
WHALE_SWITCHER_PATH=/usr/local/bin/whale-select

export DEBIAN_FRONTEND=noninteractive

PKGS=(
    containerd.io
    docker-buildx-plugin
    docker-ce
    docker-ce-cli
    docker-compose-plugin
)

# Components, a.k.a. files and directories with weird stuff, that get normally
# installed and that we need to symlink to in order to swap different
# Docker/Moby installations in and out as needed...  
COMPONENTS=(
    # containerd.io
    etc/container/config.toml
    usr/bin/containerd
    usr/bin/containerd-shim
    usr/bin/containerd-shim-runc-v1
    usr/bin/containerd-shim-runc-v2
    usr/bin/ctr
    usr/bin/runc
    # docker-buildx-plugin
    usr/libexec/docker/cli-plugins/docker-buildx
    share/doc/docker-buildx-plugin
    # docker-ce
    etc/default/docker
    etc/init.d/docker
    usr/bin/docker-proxy
    usr/bin/dockerd
    libexec/docker/docker-init
    share/doc/docker-ce
    # docker-ce-cli
    usr/bin/docker
    usr/share/bash-completion/completions/docker
    usr/share/doc/docker-ce-cli
    usr/share/fish/vendor_completions.d/docker.fish
    usr/share/zsh/vendor-completions/_docker
    # docker-compose-plugin
    usr/libexec/docker/cli-plugins/docker-compose
    usr/share/doc/docker-compose-plugin
)

# move_out moves a fresh installation during the install.sh run into its own
# versioned directory to which we can later symlink the individual components.
move_out () {
    echo "wal-wahl: stashing installed Docker/Moby away..."
    VERSION="$(/usr/bin/docker --version | cut -d ',' -f 1 | cut -d ' ' -f 3)"
    echo "wal-wahl: detected installed Docker/Moby version as ${VERSION}"
    for ELEMENT in ${COMPONENTS[@]}; do
        if [ ! -e "/${ELEMENT}" ]; then
            echo "wal-wahl: info: skipping left-out element /${ELEMENT}"
            continue
        fi
        ELEMENT_PATH="$(dirname $ELEMENT)"
        ELEMENT_NAME="$(basename $ELEMENT)"
        mkdir -p "${WHALE_SWITCH_BASE}/${VERSION}/${ELEMENT_PATH}"
        mv "/${ELEMENT}" "${WHALE_SWITCH_BASE}/${VERSION}/${ELEMENT_PATH}"
    done
}

# Note: deactivate and activate scripts are actually used only inside the
# switcher script, not during installation; however, we keep it here and then
# simply dump the function definitions (three cheers to "declare -pf") into the
# switcher script while creating the switcher. This way we don't need to pay
# attention to the correct delayed env var expansion and other nuisances...

# deactivate removes the symlinks for Docker-related package COMPONENTS, keeping
# the versioned out-of-tree installation intact. It skips elements that aren't
# symlinks when they should, warning in these cases.
deactivate () {
    echo "deactivating current Docker/Moby..."
    set +e
        pkill dockerd
        pkill containerd
    set -e
    for ELEMENT in ${COMPONENTS[@]}; do
        if [ ! -e "/${ELEMENT}" ] && [ ! -L "/${ELEMENT}" ]; then
            # element wasn't installed, so skip it silently
            continue
        elif [ ! -L "/${ELEMENT}" ]; then
            # element is installed, but isn't a symlink, so something is going
            # on here that doesn't match our expectations: better warn about it,
            # but proceed.
            echo "warning: skipping non-symlink element \"/${ELEMENT}\""
            continue
        fi
        rm "/${ELEMENT}"
    done
}

# activate a particular Docker/Moby version specified in $1; this version is
# taken as a string prefix. It fails when there are multiple versions matching
# the wanted version.
activate () {
    WANTED="$1"
    VERSIONS=(${WHALE_SWITCH_BASE}/${WANTED}*)
    for idx in "${!VERSIONS[@]}"; do
        VERSIONS[idx]=$(basename "${VERSIONS[idx]%/}")
    done
    if [ ${#VERSIONS[@]} -eq 0 ]; then
        echo "error: no version(s) found."
        exit 1
    elif [ ${#VERSIONS[@]} -gt 1 ]; then
        echo "error: ambiguous version \"${WANTED}\" specified."
        echo "available versions:"
            for V in "${VERSIONS[@]}"; do
                echo "    ${V}"
            done
        exit 1
    elif [ ! -d "${WHALE_SWITCH_BASE}/${VERSIONS[0]}" ]; then
        echo "error: no matches for \"${WANTED}\""
        exit 1
    fi

    deactivate

    VERSION="${VERSIONS[0]}"
    echo "activating ${VERSION}..."
    for ELEMENT in ${COMPONENTS[@]}; do
        ELEMENT_PATH="$(dirname $ELEMENT)"
        ELEMENT_NAME="$(basename $ELEMENT)"
        mkdir -p "/${ELEMENT_PATH}"
        ln -s "${WHALE_SWITCH_BASE}/${VERSION}/${ELEMENT}" "/${ELEMENT_PATH}/${ELEMENT_NAME}"
    done
    /usr/local/share/docker-init.sh
}

mkdir -p "${WHALE_SWITCH_BASE}"

for VERSION in ${VERSIONS//,/ }; do
    echo "wal-wahl: installing version \"${VERSION}\"..."
    env \
        VERSION="${VERSION}" \
        MOBY="${MOBY}" \
        MOBYBUILDXVERSION="${MOBYBUILDXVERSION}" \
        AZUREDNSAUTODETECTION="${AZUREDNSAUTODETECTION:-"false"}" \
        DOCKERDEFAULTADDRESSPOOL="${DOCKERDEFAULTADDRESSPOOL}" \
        DISABLEIP6TABLES="${DISABLEIP6TABLES}" \
        USERNAME="${USERNAME}" \
        DOCKERDASHCOMPOSEVERSION="none" \
        INSTALLDOCKERBUILDX="false" \
        INSTALLDOCKERCOMPOSESWITCH="false" \
            ./dind/install.sh
    if [ ! -x /usr/bin/docker ]; then
        echo "wal-wahl: fatal: installation of ${VERSION} failed due to missing docker client CLI binary"
        exit 1
    fi
    move_out
    echo "wal-wahl: removing packages ${PKGS[@]} after stashing"
    apt-mark unhold docker-ce docker-ce-cli
    for PKG in "${PKGS[@]}"; do
        echo "wal-wahl: removing ${PKG}"
        apt-get -y --purge remove "${PKG}" || true
    done
    #apt-get -y --purge remove "${PKGS[@]}" || true
done

touch "${WHALE_SWITCHER_PATH}"
chmod a+x "${WHALE_SWITCHER_PATH}"
tee "${WHALE_SWITCHER_PATH}" >> /dev/null \
<< EOF
#!/usr/bin/env bash

WHALE_SWITCH_BASE="${WHALE_SWITCH_BASE}"
COMPONENTS=( ${COMPONENTS[@]} )

$(declare -pf deactivate)
$(declare -pf activate)
$(declare -pf root)

current () {
    if [ ! -f /usr/bin/docker ]; then
        echo "none"
        exit 0
    fi
    echo "\$(docker --version | cut -d ',' -f 1 | cut -d ' ' -f 3)"
    exit 0
}

list_whales () {
    mapfile -t VERSIONS < <(ls "\${WHALE_SWITCH_BASE}")
    for VERSION in \${VERSIONS[@]}; do
        echo "\${VERSION}"
    done
    exit 0
}

case "\$1" in
    "")
        echo "usage: whale-select list|none|VERSION"
        ;;
    "none")
        if [ "\$(id -u)" -ne 0 ]; then
            echo "needs root"
            exit 1
        fi
        deactivate
        ;;
    "list"|"whales")
        list_whales
        ;;
    *)
        if [ "\$(id -u)" -ne 0 ]; then
            echo "needs root"
            exit 1
        fi
        activate "\$1"
        ;;
esac

EOF
