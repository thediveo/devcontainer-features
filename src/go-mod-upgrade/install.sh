#!/usr/bin/env bash
set -e

echo "Activating feature 'go-mod-upgrade'..."

mkdir -p /tmp/gotools
export GOCACHE=/tmp/gotools/cache

go install github.com/oligot/go-mod-upgrade@latest
