#!/usr/bin/env bash

if [[ ! -f .env ]]; then
    echo "Default build arguments don't exists. Creating one from default value."
    cp .example.env .env
fi

docker pull postgres:$POSTGRES_MAJOR_VERSION-alpine

if [[ $(dpkg -l | grep "docker-compose") > /dev/null ]];then

  docker-compose -f docker-compose.build.yml build postgres-backup-prod
else
  docker compose -f docker-compose.build.yml build postgres-backup-prod
fi