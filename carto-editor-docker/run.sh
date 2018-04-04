#!/usr/bin/env bash
set -e

source /usr/local/rvm/scripts/rvm

# Rails server is not always stopped correctly, remove pid
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# Clean up configuration directory
rm -f config/*.sample
cp config/grunt_docker.json /carto/config/grunt_$CARTO_ENV.json

# Process environment variables in configuration
sed -i "s^__DB_HOST__^$DB_HOST^g" config/database.yml
sed -i "s^__DB_PORT__^$DB_PORT^g" config/database.yml
sed -i "s^__DB_USER__^$DB_USER^g" config/database.yml

sed -i "s^__CARTO_HOST__^$CARTO_HOST^g" config/app_config.yml
sed -i "s^__CARTO_ASSET_HOST__^$CARTO_ASSET_HOST^g" config/app_config.yml
sed -i "s^__CARTO_SESSION_DOMAIN__^$CARTO_SESSION_DOMAIN^g" config/app_config.yml
sed -i "s^__CARTO_SESSION_PORT__^$CARTO_SESSION_PORT^g" config/app_config.yml
sed -i "s^__CARTO_PROTOCOL__^$CARTO_PROTOCOL^g" config/app_config.yml

sed -i "s^__REDIS_HOST__^$REDIS_HOST^g" config/app_config.yml
sed -i "s^__REDIS_PORT__^$REDIS_PORT^g" config/app_config.yml

sed -i "s^__MAP_API_HOST__^$MAP_API_HOST^g" config/app_config.yml
sed -i "s^__MAP_API_PROTOCOL__^$MAP_API_PROTOCOL^g" config/app_config.yml
sed -i "s^__MAP_API_PORT__^$MAP_API_PORT^g" config/app_config.yml

# Inform administrator
cat >&2 <<-'EOWARN'
    ****************************************************
      FIRST RUN:
        On first run, assets need to be created and you
        may want the database initialized.
        npm install . && bundle exec grunt --environment=$CARTO_ENV
        bundle exec rake db:create
        bundle exec rake db:migrate

      GENERAL:
       You should run bundle exec ./script/resque
       in a seperate process.

       rescue will polling redis keys in order to find
       pending background jobs like datasets imports
       or synchronized tables.

    ****************************************************
EOWARN
# Check gem files, or install
bundle check || bundle install

# Start resque (in background) and rails server
bundle exec ./script/resque &
bundle exec rails server
