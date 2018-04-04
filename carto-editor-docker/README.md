TODO:

* add automated build test
* add details of configuration synchronization with latest release
  - https://github.com/CartoDB/cartodb/blob/master/Gruntfile.js
  - keep CARTODB_POSTGRESQL_VERSION and Release https://github.com/CartoDB/cartodb/blob/master/README.md

* initialize user:

Trouble Shooting

* PG::Error: ERROR:  extension "cartodb" has no update path from version "unpackaged" to version "0.19.2"
  - fixed by
  - Checking out CARTODB_POSTGRESQL_VERSION

* Unable to install phantomjs-prebuilt
  - fix by install nvm and fixing the version of node to that recommended in http://cartodb.readthedocs.io/en/latest/install.html#nodejs
  - curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh -o install_nvm.sh && bash install_nvm.sh
  - nvm install v6.12.0
