#!/bin/bash

set -e

echo "Waiting for Postgres"
wait-for-it.sh ${BARGAIN_DB_HOST:-localhost}:${BARGAIN_DB_PORT:-5432} -t ${BARGAIN_DB_TIMEOUT:3000}
sleep 2

cd /bargain

echo "Clearing Crono and server pids"
rm -f /bargain/tmp/pids/server.pid
rm -f /bargain/tmp/pids/crono.pid

echo "Starting Crono"
crono start

echo "Running Docker image command: $@"
exec "$@"
