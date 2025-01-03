#!/usr/bin/env bash
set -e

echo "Activating feature 'goreportcard'..."

mkdir -p /tmp/gotools
export GOCACHE=/tmp/gotools/cache

git clone https://github.com/gojp/goreportcard.git /tmp/goreportcard
(cd /tmp/goreportcard && make install && go install ./cmd/goreportcard-cli)
rm -rf /tmp/goreportcard 

# Install a somewhat recent ineffassign over the totally outdated one that
# goreportcard still insists of infecting the system with.
go install github.com/gordonklaus/ineffassign@latest
# Install the missing misspell, oh well...
go install github.com/client9/misspell/cmd/misspell@latest
