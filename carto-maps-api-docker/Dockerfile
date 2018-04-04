FROM ubuntu:16.04
MAINTAINER Shoaib Burq <shoaib@geografia.com.au>

# Configuring locales
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y -q apt-utils && apt-get install -y -q locales && dpkg-reconfigure locales && \
      locale-gen en_US.UTF-8 && \
      update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get install -y make g++ pkg-config git-core \
  libgif-dev libjpeg-dev libcairo2-dev \
  libhiredis-dev redis-server \
  nodejs nodejs-legacy npm \
  postgresql-9.5 \
  postgresql-client-9.5 \
  postgresql-contrib-9.5 \
  postgresql-plpython-9.5 \
  postgresql-9.5-postgis-2.2 \
  postgresql-9.5-postgis-scripts \
  postgis \
  libcairo2-dev libpango1.0-dev

RUN npm install n -g && n 6
RUN npm install yarn@0.28.4 -g

RUN git clone https://github.com/cartodb/windshaft-cartodb.git /windshaft-cartodb
RUN cd /windshaft-cartodb
WORKDIR /windshaft-cartodb
ENV WINDSHAFT_STABLE_VERSION 4.0.0
RUN git checkout tags/$WINDSHAFT_STABLE_VERSION
RUN yarn
RUN mkdir logs

ENV CARTO_ENV development
ENV DB_HOST db
ENV DB_PORT 5432
ENV DB_USER postgres

ENV REDIS_HOST redis
ENV REDIS_PORT 6379
ENV CARTO_SESSION_DOMAIN carto.dev
ENV CORS_ENABLED true

ENV WINDSHAFT_PORT 8181

# Add config
COPY docker.js /windshaft-cartodb/config/environments/docker.js
# Add image configuration and scripts
COPY run.sh /run.sh
RUN chmod 755 /*.sh

CMD ["/run.sh"]
