#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

cat >main.go <<EOF
package main

func main() {
}
EOF

check "execute goreportcard-cli" bash -c "goreportcard-cli -v ./..."

reportResults
