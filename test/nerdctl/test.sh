#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "nerdctl" bash -c "nerdctl --version"

reportResults
