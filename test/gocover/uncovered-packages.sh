#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

go mod init example.com/foo

mkdir -p bar baz

cat >foo.go <<EOF
package foo

func fooed() {
    println("Fooed")
}
EOF

cat >bar/bar.go <<EOF
package bar

func Barred() {
    println("Barred")
}
EOF

cat >baz/baz.go <<EOF
package baz

func Bazzed() {
    println("Bazzed")
}
EOF

cat >foo_test.go <<EOF
package foo

import (
    "testing"

    _ "example.com/foo/bar"
    _ "example.com/foo/baz"
)

func TestFoo(t *testing.T) {
    fooed()
}
EOF

touch README.md

check "execute gocover with multiple uncovered packages" bash -c "gocover | tee /dev/tty | grep --color 'badge updated to 100.0%'"

reportResults
