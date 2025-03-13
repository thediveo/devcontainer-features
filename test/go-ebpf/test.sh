#!/usr/bin/env bash
set -e

# ensure there are not left-over build artefacts
rm -f *.o *bpfeb.go *bpfel.go

source dev-container-features-test-lib

check "build ebpf" bash -c "go generate ."
check "build artifacts" bash -c "[ -f ./goebpf_bpfeb.go ] && [ -f ./goebpf_bpfel.go ]"

reportResults
