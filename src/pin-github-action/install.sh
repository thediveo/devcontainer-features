#!/usr/bin/env bash
set -e

DOCSIFY_SERVE_PATH="/usr/local/bin/docsify-serve"

DOCS_PATH=${DOCS_PATH:-docs}

echo "Activating feature 'pin-github-action'..."
npm install -g pin-github-action
