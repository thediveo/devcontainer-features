#!/usr/bin/env bash
set -e

PORT=${PORT:-6060}

source dev-container-features-test-lib

go mod init example.com/foobar

check "execute pkgsite" bash -c "pkgsite -h"
check "execute browser-sync" bash -c "browser-sync"

check "browser-sync start nohup log exists" bash -c "[ -f /tmp/nohup-local-pkgsite-browser-sync.log ]"
cat /tmp/nohup-local-pkgsite-browser-sync.log
check "nodemon nohup log exists" bash -c "[ -f /tmp/nohup-local-pkgsite-nodemon.log ]"
cat /tmp/nohup-local-pkgsite-nodemon.log

CMD=$(cat <<EOF
curl --output /dev/null \
    --retry-connrefused --retry-delay 1 --retry 5 \
    --connect-timeout 2 --max-time 2 \
    --fail \
    http://localhost:${PORT}
EOF
)
check "serves at port ${PORT}" bash -c "${CMD}" || (
    ret=$?
    echo ---- browser-sync start log
    cat /tmp/nohup-local-pkgsite-browser-sync.log
    echo ---- nodemon log
    cat /tmp/nohup-local-pkgsite-nodemon.log
    exit ${ret}
)

reportResults
