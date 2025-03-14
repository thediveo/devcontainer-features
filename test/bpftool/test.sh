#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "bpftool" bash -c "bpftool"

reportResults
