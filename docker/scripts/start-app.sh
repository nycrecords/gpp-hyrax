#!/bin/sh

echo "### Performing application setup ###"

db-wait.sh "$DATABASE_HOST:$DATABASE_PORT"
db-wait.sh "$FCREPO_HOST:$FCREPO_PORT"
db-wait.sh "$SOLR_HOST:$SOLR_PORT"

if bundle exec rake db:exists; then
  echo "### Database exists, running migrations ###"
  bundle exec rake db:migrate
else
  echo "### Database does not exist, setting up database ###"
  bundle exec rake db:create && bundle exec rake db:migrate
fi

find . -name '*.pid' -delete
echo "#### Starting web application in $RAILS_ENV mode ####"
bundle exec puma -C config/puma.rb
echo "#### Shutdown web application ####"
