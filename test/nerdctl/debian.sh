#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

# as we're combining this test with docker-in-docker, containerd's socket isn't
# in its default location and we explicitly specify it in this feature's options
# (whalewatchers: hold my beer...)
check "nerdctl" bash -c "sudo nerdctl ps"

reportResults
