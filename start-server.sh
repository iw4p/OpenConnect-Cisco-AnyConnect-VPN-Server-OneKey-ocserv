#!/usr/bin/env bash


dd=$(docker volume ls -f "name=ocserv-data" -q)
if [ -z "$dd" ]
then
  docker volume create ocserv-data
fi


mkdir -p data
touch -a data/ocpasswd

docker kill ocserv
docker rm ocserv
docker run \
    --name ocserv \
    --privileged \
    -p 443:443 \
    -p 443:443/udp \
    -d \
    -v ocserv-data:/data ocserv
