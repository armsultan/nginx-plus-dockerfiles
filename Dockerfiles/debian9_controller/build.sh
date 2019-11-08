#!/bin/sh

API_KEY="13ae9ecdbacdf4211a174f3a56ec7f6e"
CTRL_HOST="controller.nginx.net"
LOG_LEVEL="INFO"
REPO="registry.nginx.net/nginx-plus-ctrl"
TAG="latest"
UUID="eef8fad40018531e8d2f4dd3e93ad90d"

docker rmi ${REPO}:${TAG}
docker build --tag ${REPO}:${TAG} --build-arg API_KEY=${API_KEY} --build-arg CTRL_HOST=${CTRL_HOST} --build-arg LOG_LEVEL=${LOG_LEVEL} --build-arg UUID=${UUID} .

docker push ${REPO}:${TAG}
docker rmi ${REPO}:${TAG}