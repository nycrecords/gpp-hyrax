#!/bin/sh
set -e

mkdir -p /app/doris/gpp-hyrax/tmp/pids
rm -f /app/doris/gpp-hyrax/tmp/pids/*

if [ "$RAILS_ENV" = "production" ]; then
    # Verify that production gems are installed
    bundle check
else
  if [ ! -d /app/bundle/ruby/$RUBY_MAJOR.0 ]; then
    echo "Gem directory not found. Copying gems from /usr/local/bundle..."
    mkdir -p /app/bundle/ruby/$RUBY_MAJOR.0
    cp -Rn /usr/local/bundle/* /app/bundle/ruby/$RUBY_MAJOR.0
  fi
fi

exec "$@"