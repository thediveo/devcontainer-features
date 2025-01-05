#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "pin-github-action" bash -c "pin-github-action --version | grep -E [0-9]+\.[0-9]+\.[0-9]+"

reportResults
