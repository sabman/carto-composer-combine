FROM ubuntu:trusty-20190425
MAINTAINER Shoaib <shoaib@geografa.com.au>

ENV CARTO_ENV development
ENV CARTO_DB_PREFIX cartodb_dev_user_
ENV CARTO_DB_USER_PREFIX development_cartodb_user_
ENV DB_HOST db
ENV DB_PORT 5432
ENV DB_USER postgres

ENV REDIS_HOST redis
ENV REDIS_PORT 6379

ENV REQUIRED_NODE_VERSION '6.9.2'
ENV REQUIRED_NPM_VERSION '3.10.9'

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends apt-utils make g++ git-core \
      ca-certificates \
      libicu-dev \
      gdal-bin libgdal1-dev libgdal-dev libproj-dev && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*
# install npm, nvm and nodejs
# http://cartodb.readthedocs.io/en/latest/install.html#nodejs
RUN curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh -o install_nvm.sh
RUN bash install_nvm.sh
# nvm environment variables
ENV NVM_DIR /root/.nvm
RUN . $NVM_DIR/nvm.sh && nvm install ${REQUIRED_NODE_VERSION} \
  && nvm alias default $REQUIRED_NODE_VERSION \
  && nvm use default

ENV NODE_PATH $NVM_DIR/v$REQUIRED_NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$REQUIRED_NODE_VERSION/bin:$PATH

RUN git config --global user.email docker@codefor.nl
RUN git config --global user.name "CodeForNL docker"

# ogr2ogr2 static build, see https://github.com/CartoDB/cartodb/wiki/How-to-build-gdal-and-ogr2ogr2
RUN cd /opt && git clone https://github.com/OSGeo/gdal ogr2ogr2 && cd ogr2ogr2 && \
  git remote add cartodb https://github.com/cartodb/gdal && git fetch cartodb && \
  git checkout master && git pull origin master && \
  git checkout upstream && git merge -s ours --ff-only origin/master && \
  git checkout ogr2ogr2 && git merge -s ours upstream -m "Merged it" && \
  cd ogr2ogr2 && ./configure --disable-shared && make -j 4 && \
  cp apps/ogr2ogr /usr/bin/ogr2ogr && ln -s /usr/bin/ogr2ogr /usr/bin/ogr2ogr2 && rm -rf /opt/ogr2ogr2 /root/.gitconfig

RUN git clone --depth 1 --branch master https://github.com/cartodb/cartodb-sql-api.git /cartodb-sql-api
RUN mkdir -p /cartodb-sql-api/logs
RUN mkdir -p /cartodb-sql-api/config/environments
RUN mkdir -p /tmp
WORKDIR /cartodb-sql-api

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    build-essential python-all-dev python-pip
RUN npm install -g node-gyp -v v3.4.0
RUN npm install

# Add config
COPY docker.js /cartodb-sql-api/config/environments/docker.js
# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

EXPOSE 8080
CMD ["/run.sh"]
