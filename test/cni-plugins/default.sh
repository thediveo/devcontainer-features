#!/usr/bin/env bash
set -e

CNIPLUGINS_PATH="${PLUGINS_PATH:-"/usr/lib/cni"}"

source dev-container-features-test-lib

check "bridge and macvlan plugins" bash -c "[ -x "${CNIPLUGINS_PATH}/bridge" ] && [ -x "${CNIPLUGINS_PATH}/macvlan" ]"

reportResults
