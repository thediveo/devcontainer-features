#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "execute pkgsite" bash -c "pkgsite -h"
check "execute browser-sync" bash -c "browser-sync"

reportResults
