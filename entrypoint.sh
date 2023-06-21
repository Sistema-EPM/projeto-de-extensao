#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# Run database migrations
bundle exec rails db:migrate

# Run seed.rb file
bundle exec rails db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"