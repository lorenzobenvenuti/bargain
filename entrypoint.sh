#!/bin/bash

set -e

echo "Waiting for Postgres"
wait-for-it.sh ${PRICE_TRACKER_DB_HOST:-localhost}:${PRICE_TRACKER_DB_PORT:-5432} -t ${PRICE_TRACKER_DB_TIMEOUT:3000}
sleep 2

cd /price_tracker

echo "Clearing Crono and server pids"
rm -f /price_tracker/tmp/pids/server.pid
rm -f /price_tracker/tmp/pids/crono.pid

echo "Starting Crono"
crono start

echo "Running Docker image command: $@"
exec "$@"
