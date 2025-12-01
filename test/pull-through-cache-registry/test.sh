#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

cat /etc/docker/daemon.json
check "Docker demon configuration is updated" bash -c "jq -e '.[\"registry-mirrors\"] | index(\"http://localhost:5000\")' /etc/docker/daemon.json"

check "registry service is up" bash -c "source ./wait.sh && whalewaiting registry-cache"
check "registry service responds" bash -c "source ./wait.sh && registrywaiting http://localhost:5000"

registry_ip="$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' registry-cache)"
check "default registry debug port 5001 is disabled on ${registry_ip}" bash -c "! curl -m 2 http://${registry_ip}:5001/"

reportResults
