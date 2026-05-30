#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "pinact" bash -c "pinact version | grep '3.10.1'"

reportResults
