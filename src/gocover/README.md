
# Go Coverage with Badge (gocover)

a gocover command to run Go unit tests with coverages, updating the README.md with a coverage badge.

## Example Usage

```json
"features": {
    "ghcr.io/thediveo/devcontainer-features/gocover:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| root | runs unit tests additionally as root | boolean | false |
| html | generates coverage.html | boolean | false |
| count | runs tests count times (-count) | string | 1 |
| num-programs | if set, the number of test programs that can be run in parallel (-p) | string | - |
| race | run tests with race detector enabled (-race) | boolean | true |
| verbose | run tests with -v | boolean | true |
| tags | comma-separated list of additional build tags (-tags) | string | - |
| uncovered-packages | space separated optional list of package patterns to exclude from coverage analysis | string | - |
| green | percentage number for the badge to become green | string | 80 |
| yellow | percentage number for the badge to become yellow | string | 50 |

## Feature Dependency

This feature has only a soft dependecy on `ghcr.io/devcontainers/features/go` so
that you have full control over from where and how you bring in the go
toolchain.

For example:

```json
{
    "features": {
        "ghcr.io/devcontainers/features/go:1": {},
        "ghcr.io/thediveo/devcontainer-features/gocover:1": {}
    }
}
```

## `gocover` Command

This feature installs a new `gocover` command into `/usr/local/bin`.

When run without any flags and arguments, `gocover` will run the unit tests
using `go test` on all packages in the Go module in the workspace, and update
the `README.md` file with a badge showing the coverage percentage.

### `gocover` CLI Flags

| Flag | Meaning |
| --- | --- |
| `-r`, `-root`, `--root` | run tests additionally also as root. |
| `-noroot`, `--no-root` | don't run tests also as root, even if this feature was configured with `root`:`true`. |
| `-html`, `--html` | additionally generate `coverage.html` |
| `-nohtml`, `--no-html` | don't generate `coverage.html`, even if this feature was configured with `html`:`true`. |

### Positional Arguments

Positional arguments specify the package(s) to run unit tests on and collect
coverage from.

## OS Support

Tested only with
[mcr.microsoft.com/devcontainers/base:ubuntu](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/about#about:_ubuntu).


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/thediveo/devcontainer-features/blob/main/src/gocover/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
