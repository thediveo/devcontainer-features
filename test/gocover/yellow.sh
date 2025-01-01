#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

go mod init example.com/foo

cat >foo.go <<EOF
package foo

func fooed() {
    println("Fooed")
}

func rooted() {
    println("Rooted")
}
EOF

cat >foo_test.go <<EOF
package foo

import (
    "os"
    "testing"
)

func TestFoo(t *testing.T) {
    fooed()
}

func TestRoot(t *testing.T) {
    if os.Getuid() != 0 {
        t.Skip("needs root")
    }
    rooted()
}
EOF

touch README.md

check "execute gocover" bash -c "gocover | tee /dev/tty | grep --color 'badge updated to 50.0%'"

check "coverage badge is red" bash -c "grep img.shields.io README.md && grep --color 'https://img.shields.io/badge/Coverage-50.0%25-red' README.md"

check "execute gocover with --root" bash -c "gocover --root | tee /dev/tty | grep --color 'badge updated to 100.0%'"

check "coverage badge is green" bash -c "grep img.shields.io README.md && grep --color 'https://img.shields.io/badge/Coverage-100.0%25-brightgreen' README.md"

reportResults
