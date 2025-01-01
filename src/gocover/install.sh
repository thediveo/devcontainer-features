#!/usr/bin/env bash
set -e

GOCOVER_PATH="/usr/local/bin/gocover"

ROOT=${ROOT:-false}
HTML=${HTML:-false}
COUNT=${COUNT:-1}
NUM_PROGRAMS=${NUM_PROGRAMS} # ...just a reminder
RACE=${RACE:-true}
VERBOSE=${VERBOSE:-true}
GREEN=${GREEN:-80}
YELLOW=${YELLOW:-50}

echo "Activating feature 'gocoverbadge'..."

go install github.com/AlexBeauchemin/gobadge@latest

tee "${GOCOVER_PATH}" > /dev/null \
<< EOF
#!/usr/bin/env bash

ROOT="${ROOT}"
HTML="${HTML}"
COUNT="${COUNT}"
NUM_PROGRAMS="${NUM_PROGRAMS}"
RACE="${RACE}"
VERBOSE="${VERBOSE}"
POSARGS=()
while [[ \$# -gt 0 ]]; do
    case \$1 in
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
        *)
            POSARGS+=("\$1")
            shift
            ;;
    esac
done

# First, we set up a temporary directory to receive the coverage (binary)
# files...
GOCOVERTMPDIR="\$(mktemp -d)"
trap 'rm -rf -- "\${GOCOVERTMPDIR}"' EXIT

# Now run the (unit) tests with coverage, but don't use the existing textual
# format and instead tell "go test" to produce the new binary coverage data file
# format. This way we can easily run multiple coverage (integration) tests, as
# needed, without worrying about how to aggregate the coverage data later. The
# new Go toolchain already does this for us.
[[ -n "\${NUM_PROGRAMS}" ]] && NUM_PROGRAMS="-p=\${NUM_PROGRAMS}"
[[ "\${ROOT}" = "true" ]] && ROOT="-exec=sudo" || unset ROOT
[[ "\${RACE}" = "true" ]] && RACE="-race" || unset RACE
[[ "\${VERBOSE}" = "true" ]] && VERBOSE="-v" || unset VERBOSE

[[ \${#POSARGS[@]} -eq 0 ]] && POSARGS+="./..."

if [[ -n "\${ROOT+x}" ]]; then
    go test -cover \
        \${ROOT} \
        \${VERBOSE} \
        \${RACE} \
        -count=\${COUNT} \${NUM_PROGRAMS} \
        \${POSARGS[@]} -args -test.gocoverdir="\${GOCOVERTMPDIR}"
fi
go test -cover \
    \${VERBOSE} \
    \${RACE} \
    -count=\${COUNT} \${NUM_PROGRAMS} \
    \${POSARGS[@]} -args -test.gocoverdir="\${GOCOVERTMPDIR}"

# Finally transform the coverage information collected in potentially multiple
# runs into the well-proven textual format so we can process it as we have come
# to learn and love.
go tool covdata textfmt -i="\${GOCOVERTMPDIR}" -o="\${GOCOVERTMPDIR}/coverage.out"
if [[ "\${HTML}" = "true" ]]; then
    go tool cover -html="\${GOCOVERTMPDIR}/coverage.out" -o=coverage.html
fi
go tool cover -func="\${GOCOVERTMPDIR}/coverage.out" -o=/proc/self/fd/1 \
    | gobadge -filename=/proc/self/fd/0 -green=${GREEN} -yellow=${YELLOW}
EOF
chmod 0755 "${GOCOVER_PATH}"