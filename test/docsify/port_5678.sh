#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

CMD=$(cat <<EOF
curl --output /dev/null \
    --retry-connrefused --retry-delay 1 --retry 3 \
    --head --fail \
    http://localhost:5678
EOF
)
check "serves at port 5678" bash -c "${CMD}"

reportResults
