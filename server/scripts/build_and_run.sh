#!/bin/bash

echo "Stopping previous instance..."

docker stop $(docker ps -q --filter ancestor=bingobongo )

docker build . -t bingobongo

docker tag bingobongo:latest bingobongo:$(git rev-parse --short HEAD)

docker run -d -it -p 8022:8080 bingobongo