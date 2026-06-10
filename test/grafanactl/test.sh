#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "gcx" bash -c "gcx --version | grep -E 'gcx version [0-9]+\.[0-9]+\.[0-9]+ built from'"

reportResults
