#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "nerdctl" bash -c "nerdctl --version"

check "no CNI plugins" bash -c "[ ! -x /usr/libexec/cni/firewall ]"

reportResults
