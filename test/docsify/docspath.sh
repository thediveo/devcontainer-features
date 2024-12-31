#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "default files at configured path exist" bash -c "[ -f foobar/README.md ]" 

CMD=$(cat <<EOF
curl --output /dev/null \
    --retry-connrefused --retry-delay 1 --retry 3 \
    --silent --head --fail \
    http://localhost:3300
EOF
)
check "serves at port 3300" bash -c "${CMD}"

reportResults
