#!/bin/bash

set -e

cd /bargain

echo "Performing database migrations"
rails db:migrate
