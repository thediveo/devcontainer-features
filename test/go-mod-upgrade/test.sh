#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

go mod init example.com/foo

check "execute go-mod-upgrade" bash -c "go-mod-upgrade | grep 'modules are up to date'"

reportResults
