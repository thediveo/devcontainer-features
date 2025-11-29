#!/bin/bash

whalewaiting() {
    local container="$1"
    local timeout="${2:-30}"

    while true; do
        if docker ps --filter "name=^${container}$" --filter "status=running" --format '{{.Names}}' |
            grep -qx "${container}"; then
                return 0
        fi
        sleep 1
        timeout=$((timeout-1))
        if [ "$timeout" -le 0 ]; then
            exit 1
        fi
    done
}

registrywaiting() {
    local url="$1"
    local timeout="${2:-10}"

    while true; do
        if curl -s -o /dev/null -w "%{http_code}" "${url}/v2/" | grep -q '200'; then
            return 0
        fi
        sleep 1
        timeout=$((timeout-1))
        if [ "$timeout" -le 0 ]; then
            exit 1
        fi
    done
}
