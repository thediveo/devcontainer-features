#!/usr/bin/env bash

set -e

REGISTRYDEPLOYSCRIPT_PATH="/usr/local/bin/registry-pull-through-cache"
DOCKERDCONFIG_PATH="/etc/docker/daemon.json"

PROXY_REMOTE_URL=${PROXY_REMOTE_URL:-"https://registry-1.docker.io"}
PORT=${PORT:-5000}
TTL=${TTL:-168h}
REGISTRY_NAME=${REGISTRY_NAME:-"registry-cache"}
WAIT=${WAIT:-30}

echo "installing feature registry-pull-through-cache"

cat <<EOF >"${REGISTRYDEPLOYSCRIPT_PATH}"
PROXY_REMOTE_URL=${PROXY_REMOTE_URL}
PORT="${PORT}"
TTL="${TTL}"
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
        -e REGISTRY_PROXY_TTL="\${TTL}" \
        -e REGISTRY_HTTP_DEBUG= \
        -e REGISTRY_LOG_LEVEL=info \
        -e OTEL_TRACES_EXPORTER=none \
        registry:3
fi
echo "pull-through cache registry started"
EOF

echo generating ${DOCKERDCONFIG_PATH} configuring registry-mirrors
if [ ! -f "${DOCKERDCONFIG_PATH}" ]; then
    echo '{}' > "${DOCKERDCONFIG_PATH}"
fi
jq --arg port "${PORT}" '.["registry-mirrors"] = [ "http://localhost:" + $port ]' "${DOCKERDCONFIG_PATH}" > "${DOCKERDCONFIG_PATH}.new"
mv "${DOCKERDCONFIG_PATH}.new" "${DOCKERDCONFIG_PATH}"

chmod 0755 "${REGISTRYDEPLOYSCRIPT_PATH}"
