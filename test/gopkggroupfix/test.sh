#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "pkg dir exists" bash -c "[[ -d /go/pkg ]]"
check "pkg dir has golang group" bash -c "[[ \"$(stat -c '%G' /go/pkg)\" == \"golang\" ]]"
check "pkg dir is golang group writable" bash -c "[[ \"$(stat -c '%A' /go/pkg)\" == \"drwxrwsr-x\" ]]"

reportResults
