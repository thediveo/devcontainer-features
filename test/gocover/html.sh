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

check "execute gocover with html=true" bash -c "gocover | tee /dev/tty | grep --color 'badge updated to'"
check "coverage.html" bash -c "[[ -f coverage.html ]]"

reportResults
