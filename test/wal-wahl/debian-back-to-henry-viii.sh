#!/usr/bin/env bash
set -e

MOBY_A="20"
MOBY_B="26"

source dev-container-features-test-lib

check "whale selector script should be available" bash -c "[ -f /usr/local/bin/whale-select ]"

check "docker client command doesn't exist in standard location" bash -c "[ ! -f /usr/bin/docker ]"

check "list available versions" bash -c "whale-select list | grep -Pzl '$(printf '(?s)\s*%s\.\d+\.\d+\\n\s*%s\.\d+\.\d+' ${MOBY_A} ${MOBY_B})'"

check "activation needs root" bash -c "whale-select ${MOBY_A} | grep 'needs root'"

check "ambiguous version" bash -c "sudo whale-select 2 | grep -Pzl '$(printf '(?s)error: ambiguous version "2" specified.\\navailable versions:\\n\s*%s\..*\\n\s*%s\.' ${MOBY_A} ${MOBY_B})'"

check "activate one version" bash -c "sudo whale-select ${MOBY_A} && docker --version | grep -P '$(printf '%s\.\d+\.\d+' ${MOBY_A})'"

check "activate another version" bash -c "sudo whale-select ${MOBY_B} && docker --version | grep -P '$(printf '%s\.\d+\.\d+' ${MOBY_B})'"

check "deactivate" bash -c "sudo whale-select none && [ ! -f /usr/bin/docker ]"

reportResults
