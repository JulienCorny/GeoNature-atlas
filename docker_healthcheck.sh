#!/bin/bash
# docker healthcheck ATLAS
url_test=http://localhost:8080${ATLAS_APPLICATION_ROOT}/
if [ ! -f /tmp/container_healthy ]; then
    curl -f "${url_test}" || exit 1
    touch /tmp/container_healthy
fi