## `gocover` Command

This feature installs a new `gocover` command into `/usr/local/bin`.

When run without any flags and arguments, `gocover` will run the unit tests
using `go test` on all packages in the Go module in the workspace, and update
the `README.md` file with a badge showing the coverage percentage.

### CLI Flags

| Flag | Meaning |
| --- | --- |
| `-r`, `-root`, `--root` | run tests additionally also as root. |
| `-noroot`, `--no-root` | don't run tests also as root, even if feature was configured with root=true. |
| `-html`, `--html` | additionally generate `coverage.html` |
| `-nohtml`, `--no-html` | don't generate `coverage.html, even if feature was configured with html=true. |

### Positional Arguments

Positional arguments specify the package(s) to run unit tests on and collect
coverage from.

## OS Support

Tested only with
[mcr.microsoft.com/devcontainers/base:ubuntu](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/about#about:_ubuntu).
