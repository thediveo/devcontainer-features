#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

go mod init example.com/foo

cat >foo.go <<EOF
package foo

func fooed() {
    println("Fooed")
}
EOF

cat >foo_test.go <<EOF
package foo

import (
    "testing"
)

func TestFoo(t *testing.T) {
    fooed()
}

func Example_crash() {
    panic("THOU SHALT NOT TEST THIS EXAMPLE")
    // Output:
}
EOF

touch README.md

check "run only tests but no examples" bash -c "gocover | tee /dev/tty | grep --color -E 'badge updated to 100.0%'"

reportResults
