#!/bin/bash

set -e

cd /price_tracker

echo "Clearing Crono and server pids"
rm -f /price_tracker/tmp/pids/server.pid
rm -f /price_tracker/tmp/pids/crono.pid

echo "Starting Crono"
crono start

echo "Running Docker image command: $@"
exec "$@"
