#!/usr/bin/env bash

if [ "$(ls -A cert)" ]; then
  DOCKER_FILE="Dockerfile"
else
  DOCKER_FILE="Dockerfile.cert"
fi

docker build -t ocserv -f "$DOCKER_FILE" .
