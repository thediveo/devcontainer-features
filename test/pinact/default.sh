#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "pinact" bash -c "pinact version | grep -E '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+'"

reportResults
