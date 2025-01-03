#!/usr/bin/env bash
set -e

PKGSITE_SERVE_PATH="/usr/local/bin/pkgsite-serve"

PORT=${PORT:-6060}
RELOAD_DELAY=${RELOAD_DELAY:-2000}
RELOAD_DEBOUNCE=${RELOAD_DEBOUNCE:-5000}

echo "Activating feature 'local-pkgsite'..."

mkdir -p /tmp/gotools
export GOCACHE=/tmp/gotools/cache

go install golang.org/x/pkgsite/cmd/pkgsite@latest
PKGSITE_BIN=$(which pkgsite)

npm -g install browser-sync
npm -g install nodemon

tee "${PKGSITE_SERVE_PATH}" > /dev/null \
<< EOF
#!/usr/bin/env sh
INT_PORT=$(comm -23 <(seq 49152 65535 | sort) \
    <(netstat -ntl | awk '/LISTEN/ {split($4,a,":"); print a[2]}' | sort -u) 2>/dev/null \
    | shuf | head -n 1)
nohup bash -c "browser-sync start --port ${PORT} --proxy localhost:\${INT_PORT} --reload-delay ${RELOAD_DELAY} --reload-debounce ${RELOAD_DEBOUNCE} --no-ui --no-open &" >/tmp/nohup-browser-sync.log 2>&1
nohup bash -c "nodemon --signal SIGTERM --watch './**/*' -e go --watch 'go.mod' --exec \"browser-sync --port ${PORT} reload && ${PKGSITE_BIN} -http=localhost:\${INT_PORT} .\" &" >/tmp/nohup.log 2>&1
EOF
chmod 0755 "${PKGSITE_SERVE_PATH}"
