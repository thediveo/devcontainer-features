#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "registry service is up" bash -c "source ./wait.sh && whalewaiting registry-cache"
check "registry service responds" bash -c "source ./wait.sh && registrywaiting http://localhost:5000"
check "pulling an image" bash -c "docker pull quay.io/libpod/busybox | tee >(grep 'quay.io/libpod/busybox:latest')"

reportResults
