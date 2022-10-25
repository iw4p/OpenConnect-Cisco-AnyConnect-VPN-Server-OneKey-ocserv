#!/usr/bin/env bash

if [ "$(ls -A cert)" ]; then
  DOCKER_FILE="Dockerfile.cert"
else
  DOCKER_FILE="Dockerfile"
fi

echo $DOCKER_FILE

docker build -t ocserv -f "$DOCKER_FILE" .
