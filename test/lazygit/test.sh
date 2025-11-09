#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "lazygit" bash -c "lazygit --version | grep -E 'version=[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+,'"

reportResults
