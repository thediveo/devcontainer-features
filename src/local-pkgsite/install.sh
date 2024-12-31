#!/usr/bin/env bash
set -e

echo "Activating feature 'local-pkgsite'"

go install golang.org/x/pkgsite/cmd/pkgsite@latest
npm -g install browser-sync
npm -g install nodemon
