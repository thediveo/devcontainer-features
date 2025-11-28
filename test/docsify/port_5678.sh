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

check "serves live-reload at port 5679" bash -c \
    "lsof -nP -iTCP:5679 -sTCP:LISTEN | awk 'NR>1 {print \$2}' | sort -u | (read PID && ps -p \$PID -o cmd= | grep -q 'node')"

reportResults
