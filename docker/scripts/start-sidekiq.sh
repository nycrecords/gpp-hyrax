#!/bin/sh

echo "#### Running start-sidekiq.sh ####"

host=$(printf "%s\n" "$1"| cut -d : -f 1)
port=$(printf "%s\n" "$1"| cut -d : -f 2)

shift 1

while ! nc -z "$host" "$port"
do
  echo "Waiting for $host:$port..."
  sleep 5
done

echo "$host now available, starting service..."
echo "#### Starting sidekiq ####"
bundle exec sidekiq
echo "#### Shutdown sidekiq ####"
