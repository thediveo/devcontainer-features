#!/usr/bin/env bash
set -e

DOCSIFY_SERVE_PATH="/usr/local/bin/docsify-serve"
DOCSIFY_FALLBACK_PATH="/usr/local/share/docsify-serve/fallback"

DOCS_PATH=${DOCS_PATH:-docs}

echo "Activating feature 'docsify-cli'..."

npm install -g docsify-cli

mkdir -p "${DOCSIFY_FALLBACK_PATH}"
cp fallback/index.html fallback/README.md "${DOCSIFY_FALLBACK_PATH}"

cat <<EOF >"${DOCSIFY_SERVE_PATH}"
#!/usr/bin/env bash

# we need to explicitly "activate" (the current) node here, as otherwise
# devcontainers using our feature and also setting their remoteEnv PATH will
# cause our script to fail when run as the postStartCommand. Moreover, as this
# script will be run in a non-login shell using a plain "docker exec -it ...",
# we thus don't have the profile settings ready.

. /usr/local/share/nvm/nvm.sh
nvm use node

mkdir -p "${DOCS_PATH}"
if [ ! -f "${DOCS_PATH}/index.html" ]; then
    cp ${DOCSIFY_FALLBACK_PATH}/* "${DOCS_PATH}"
fi

# since this script is going to be executed as this feature's
# "postStartCommand" there is an important catch here: it is run via
# "docker exec -it ...". Please notice the absence of "-d" as this is a
# synchronous operation. Just using "nohup" as shown in several cases is
# a bad idea: when postStartCommand finishes, it tears down the nohup.
# Thus, use setsid(1) (https://man7.org/linux/man-pages/man1/setsid.1.html)
# to run the docsify serve node process in a new session.
echo "starting \"docsify serve\" in the background..."
LOGFILE=/tmp/nohup-feature-docsify.log
setsid --fork bash -c "\
    docsify serve \
        -p=${PORT} \
        -P=${LIVERELOAD_PORT} \
        --no-open \
        ${DOCS_PATH} \
    >\${LOGFILE} 2>&1"
# wait for the background'ed bash running "docsify serve ..." to have created
# the log file, as at this point we're sure this bash process has been
# disassociated from the current session and will now not be affected any longer
# when we exit.
now=\$(date +%s)
end=\$((now + 5))
while true; do
    if [ -s "\${LOGFILE}" ]; then
        echo "...docsify started"
        break
    fi
    now=\$(date +%s)
    if [ "\${now}" -ge "\${end}" ]; then
        echo "ERROR: docsify didn't start"
        break
    fi
    sleep 0.25
done
EOF

chmod 0755 "${DOCSIFY_SERVE_PATH}"
