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

check "execute gocover" bash -c "gocover | tee /dev/tty | grep --color -E 'badge updated to 50.0%'"

check "coverage badge is yellow" bash -c "grep img.shields.io README.md && grep --color 'https://img.shields.io/badge/Coverage-50.0%25-yellow' README.md"

check "expect verbose output" bash -c "gocover | grep --color -E '=== RUN   TestFoo'"

check "coverage with --root" bash -c "gocover --root | tee /dev/tty | grep --color 'badge updated to 100.0%'"

check "coverage with --html" bash -c "gocover --html && [[ -f coverage.html ]]"

reportResults
