#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "gcx 0.4.0" bash -c "gcx --version | grep -E 'gcx version 0.4.0 built from'"

reportResults
