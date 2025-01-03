#!/usr/bin/env bash
set -e

echo "Activating feature 'gopkggroupfix'..."

mkdir -p /go/pkg
chmod -R g+w /go/pkg
