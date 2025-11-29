#!/usr/bin/env bash

set -e

REGISTRYDEPLOYSCRIPT_PATH="/usr/local/bin/registry-pull-through-cache"

PROXY_REMOTE_URL=${PROXY_REMOTE_URL:-"https://registry-1.docker.io"}
PORT=${PORT:-5000}
REGISTRY_NAME=${REGISTRY_NAME:-"registry-cache"}
WAIT=${WAIT:-30}

echo "installing feature registry-pull-through-cache"

cat <<EOF >"${REGISTRYDEPLOYSCRIPT_PATH}"
PROXY_REMOTE_URL=${PROXY_REMOTE_URL}
PORT="${PORT}"
REGISTRY_NAME="${REGISTRY_NAME}"

timeout=${WAIT}
echo "waiting up to ${WAIT}s for Docker daemon to become responsive..."
while ! docker ps >/dev/null 2>&1; do
    sleep 1
    timeout=$((timeout-1))
    if [ "$timeout" -le 0 ]; then
        echo "Docker did not become responsive, aborting"
        exit 1
    fi
done

if docker ps -a --format '{{.Names}}' | grep -q "^\${REGISTRY_NAME}$"; then
    echo "(re)starting pull-through cache registry container"
    docker start "\${REGISTRY_NAME}"
else
    echo "running pull-through cache registry container"
    docker run -d \
        --restart always \
        --name "\${REGISTRY_NAME}" \
        -p \${PORT}:5000 \
        -e REGISTRY_PROXY_REMOTEURL="\${PROXY_REMOTE_URL}" \
        -e REGISTRY_LOG_LEVEL=info \
        -e OTEL_TRACES_EXPORTER=none \
        registry:3
fi
echo "pull-through cache registry started"
EOF

echo generating /etc/docker/daemon.json configuring registry-mirrors
cat <<EOF >/etc/docker/daemon.json
{
  "registry-mirrors": [ "http://localhost:${PORT}" ]
}
EOF

chmod 0755 "${REGISTRYDEPLOYSCRIPT_PATH}"
