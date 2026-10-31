#!/usr/bin/env bash
set -Eeuo pipefail

GOCOVER_PATH="/usr/local/bin/gocover"

ROOT="${ROOT:-false}"
HTML="${HTML:-false}"
COUNT="${COUNT:-1}"
NUM_PROGRAMS="${NUM_PROGRAMS:-}"
RACE="${RACE:-true}"
RUN="${RUN:-}"
TAGS="${TAGS:-}"
VERBOSE="${VERBOSE:-true}"
GREEN="${GREEN:-80}"
YELLOW="${YELLOW:-50}"

IGNORE_PKGS=()

if [[ -n "${UNCOVERED_PACKAGES:-}" ]]; then
    IFS=',' read -r -a IGNORE_PKGS <<< "${UNCOVERED_PACKAGES}"
fi

# Validate installation configuration.
[[ "${ROOT}" == "true" || "${ROOT}" == "false" ]] || {
    echo "ERROR: ROOT must be true or false." >&2
    exit 1
}

[[ "${HTML}" == "true" || "${HTML}" == "false" ]] || {
    echo "ERROR: HTML must be true or false." >&2
    exit 1
}

[[ "${RACE}" == "true" || "${RACE}" == "false" ]] || {
    echo "ERROR: RACE must be true or false." >&2
    exit 1
}

[[ "${VERBOSE}" == "true" || "${VERBOSE}" == "false" ]] || {
    echo "ERROR: VERBOSE must be true or false." >&2
    exit 1
}

[[ "${COUNT}" =~ ^[1-9][0-9]*$ ]] || {
    echo "ERROR: COUNT must be a positive integer." >&2
    exit 1
}

[[ -z "${NUM_PROGRAMS}" || "${NUM_PROGRAMS}" =~ ^[1-9][0-9]*$ ]] || {
    echo "ERROR: NUM_PROGRAMS must be a positive integer." >&2
    exit 1
}

for value in "${GREEN}" "${YELLOW}"; do
    [[ "${value}" =~ ^[0-9]+$ ]] && (( value <= 100 )) || {
        echo "ERROR: GREEN and YELLOW must be between 0 and 100." >&2
        exit 1
    }
done

echo "Activating feature 'gocoverbadge'..."

# Install gobadge.
go install github.com/AlexBeauchemin/gobadge@latest

GOBADGE="$(go env GOBIN)"
[[ -n "${GOBADGE}" ]] || GOBADGE="$(go env GOPATH)/bin"

if [[ ! -x "${GOBADGE}/gobadge" ]]; then
    echo "ERROR: gobadge installation failed." >&2
    exit 1
fi

install -m 0755 "${GOBADGE}/gobadge" /usr/local/bin/gobadge

# Generate gocover.
{
    cat <<'EOF'
#!/usr/bin/env bash

set -Eeuo pipefail

EOF

    # Safely serialize configuration variables.
    declare -p ROOT HTML COUNT NUM_PROGRAMS RACE RUN TAGS VERBOSE GREEN YELLOW IGNORE_PKGS

    cat <<'EOF'

POSARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|-root|--root)
            ROOT="true"
            shift
            ;;
        -noroot|--no-root)
            ROOT="false"
            shift
            ;;
        -html|--html)
            HTML="true"
            shift
            ;;
        -nohtml|--nohtml)
            HTML="false"
            shift
            ;;
        -tags|--tags)
            if [[ $# -lt 2 ]]; then
                echo "ERROR: --tags requires an argument." >&2
                exit 1
            fi
            TAGS="$2"
            shift 2
            ;;
        *)
            POSARGS+=("$1")
            shift
            ;;
    esac
done

# Validate runtime configuration.
[[ "${ROOT}" == "true" || "${ROOT}" == "false" ]] || {
    echo "ERROR: ROOT must be true or false." >&2
    exit 1
}

[[ "${HTML}" == "true" || "${HTML}" == "false" ]] || {
    echo "ERROR: HTML must be true or false." >&2
    exit 1
}

[[ "${RACE}" == "true" || "${RACE}" == "false" ]] || {
    echo "ERROR: RACE must be true or false." >&2
    exit 1
}

[[ "${VERBOSE}" == "true" || "${VERBOSE}" == "false" ]] || {
    echo "ERROR: VERBOSE must be true or false." >&2
    exit 1
}

[[ "${COUNT}" =~ ^[1-9][0-9]*$ ]] || {
    echo "ERROR: Invalid COUNT." >&2
    exit 1
}

# Default package selection.
if [[ ${#POSARGS[@]} -eq 0 ]]; then
    POSARGS+=("./...")
fi

# Determine packages included in coverage.
COVERPKG=()

if (( ${#IGNORE_PKGS[@]} > 0 )); then

    # Discover packages and propagate go list failures.
    if ! PKG_OUTPUT="$(go list ./...)"; then
        echo "ERROR: Failed to discover Go packages." >&2
        exit 1
    fi

    ALL_PKGS=()
    mapfile -t ALL_PKGS <<< "${PKG_OUTPUT}"

    COVERPKG_LIST=()

    for pkg in "${ALL_PKGS[@]}"; do
        excluded=false

        for ignored in "${IGNORE_PKGS[@]}"; do
            if [[ "${pkg}" == "${ignored}" ]]; then
                excluded=true
                break
            fi
        done

        if [[ "${excluded}" == false ]]; then
            COVERPKG_LIST+=("${pkg}")
        fi
    done

    if (( ${#COVERPKG_LIST[@]} == 0 )); then
        echo "ERROR: No packages remain for coverage." >&2
        exit 1
    fi

    COVERPKG+=("-coverpkg=$(IFS=,; echo "${COVERPKG_LIST[*]}")")
fi

# Create temporary coverage directory.
GOCOVERTMPDIR="$(mktemp -d)"
trap 'rm -rf -- "${GOCOVERTMPDIR}"' EXIT

# Construct common Go test arguments.
GO_ARGS=(
    -cover
    "-count=${COUNT}"
)

[[ "${RACE}" == "true" ]] && GO_ARGS+=(-race)
[[ "${VERBOSE}" == "true" ]] && GO_ARGS+=(-v)
[[ -n "${NUM_PROGRAMS}" ]] && GO_ARGS+=("-p=${NUM_PROGRAMS}")
[[ -n "${TAGS}" ]] && GO_ARGS+=("-tags=${TAGS}")
[[ -n "${RUN}" ]] && GO_ARGS+=("-run=${RUN}")

GO_ARGS+=("${COVERPKG[@]}")

# Execute tests as root when requested.
if [[ "${ROOT}" == "true" ]]; then
    ROOT_ARGS=("${GO_ARGS[@]}" -exec=sudo)
    ROOT_ARGS+=("${POSARGS[@]}")
    ROOT_ARGS+=(-args "-test.gocoverdir=${GOCOVERTMPDIR}")

    go test "${ROOT_ARGS[@]}"
fi

# Execute tests as the current user.
USER_ARGS=("${GO_ARGS[@]}")
USER_ARGS+=("${POSARGS[@]}")
USER_ARGS+=(-args "-test.gocoverdir=${GOCOVERTMPDIR}")

go test "${USER_ARGS[@]}"

# Convert binary coverage data to textual format.
go tool covdata textfmt \
    -i="${GOCOVERTMPDIR}" \
    -o="${GOCOVERTMPDIR}/coverage.out"

# Generate HTML report.
if [[ "${HTML}" == "true" ]]; then
    go tool cover \
        -html="${GOCOVERTMPDIR}/coverage.out" \
        -o=coverage.html
fi

# Generate coverage badge.
go tool cover \
    -func="${GOCOVERTMPDIR}/coverage.out" \
    | gobadge \
        -filename=/dev/stdin \
        -green="${GREEN}" \
        -yellow="${YELLOW}"

EOF
} > "${GOCOVER_PATH}"

chmod 0755 "${GOCOVER_PATH}"

echo "gocoverbadge installed successfully."
