#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "execute pkgsite" bash -c "pkgsite -h"
check "execute browser-sync" bash -c "browser-sync"

go mod init example.com/foobar

CMD=$(cat <<EOF
curl --output /dev/null \
    --retry-connrefused --retry-delay 1 --retry 5 \
    --connect-timeout 2 --max-time 3 \
    --fail \
    http://localhost:6060
EOF
)
check "serves at port 6060" bash -c "${CMD}"

reportResults
