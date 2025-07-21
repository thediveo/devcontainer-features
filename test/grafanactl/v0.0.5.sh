#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "grafanactl" bash -c "grafanactl --version | grep -E 'grafanactl version 0.0.5 built from'"

reportResults
