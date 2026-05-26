#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

go mod init example.com/foo

check "execute go-mod-upgrade" bash -c "go-mod-upgrade --version | grep \"module version: v0.13.0-beta.0\""

reportResults
