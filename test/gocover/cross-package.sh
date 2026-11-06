#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

go mod init example.com/foo

mkdir -p bar

cat >bar/bar.go <<EOF
package bar

func Barred() {
    println("Barred")
}

func Bazzed() {
    println("Bazzed")
}
EOF

# bar's own test leaves Barred uncovered, only foo's test covers it.
cat >bar/bar_test.go <<EOF
package bar

import "testing"

func TestBar(t *testing.T) {
    Bazzed()
}
EOF

cat >foo.go <<EOF
package foo

import "example.com/foo/bar"

func fooed() {
    bar.Barred()
}
EOF

cat >foo_test.go <<EOF
package foo

import "testing"

func TestFoo(t *testing.T) {
    fooed()
}
EOF

touch README.md

check "counts coverage of packages exercised only by other packages' tests" bash -c "gocover | tee /dev/tty | grep --color 'badge updated to 100.0%'"

reportResults
