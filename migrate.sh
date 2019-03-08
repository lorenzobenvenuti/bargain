#!/bin/bash

set -e

cd /price_tracker

echo "Performing database migrations"
rails db:migrate
