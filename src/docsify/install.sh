#!/usr/bin/env bash
set -e

DOCSIFY_SERVE_PATH="/usr/local/bin/docsify-serve"
DOCSIFY_FALLBACK_PATH="/usr/local/share/docsify-serve/fallback"

PORT=${PORT:-3300}
DOCS_PATH=${DOCS_PATH:-docs}
RELOAD_DELAY=${RELOAD_DELAY:2000}
RELOAD_DEBOUNCE=${RELOAD_DEBOUNCE:5000}

echo "Activating feature 'docsify'..."

npm -g install browser-sync

mkdir -p "${DOCSIFY_FALLBACK_PATH}"
cp fallback/index.html fallback/README.md "${DOCSIFY_FALLBACK_PATH}"

cat <<EOF >"${DOCSIFY_SERVE_PATH}"
#!/usr/bin/env bash

# we need to explicitly "activate" (the current) node here, as otherwise
# devcontainers using our feature and also setting their remoteEnv PATH will
# cause our script to fail when run as the postStartCommand. 
. /usr/local/share/nvm/nvm.sh
nvm use node

mkdir -p "${DOCS_PATH}"
if [ ! -f "${DOCS_PATH}/index.html" ]; then
    cp ${DOCSIFY_FALLBACK_PATH}/* "${DOCS_PATH}"
fi

wait_for_process_logfile() {
    local name=\$1
    local file=\$2
    local now=\$(date +%s)
    local end=\$((now + 5))
    while true; do
        if [ -s "\${file}" ]; then
            echo "🚀 \${name} started"
            break
        fi
        now=\$(date +%s)
        if [ "\${now}" -ge "\${end}" ]; then
            echo "❌ ERROR: \${name} did not start"
            break
        fi
        sleep 0.25
    done
}

# Start browser-sync in the background to serve the docsified contents, watching
# for changes, and triggering browser reloads.
BROWSYNC_LOGFILE=/tmp/nohup-feature-docsify.log
setsid --fork bash -c "\
    browser-sync \
        "${DOCS_PATH}" \
        --port ${PORT} \
        --reload-delay ${RELOAD_DELAY} \
        --reload-debounce ${RELOAD_DEBOUNCE} \
        --no-ui \
        --no-open \
        -w \
    >\${BROWSYNC_LOGFILE} 2>&1"
wait_for_process_logfile "browser-sync" \${BROWSYNC_LOGFILE}
EOF
chmod 0755 "${DOCSIFY_SERVE_PATH}"
