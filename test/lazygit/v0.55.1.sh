#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "lazygit" bash -c "lazygit --version | grep 'version=0.55.1,'"

reportResults
