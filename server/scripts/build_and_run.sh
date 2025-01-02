#!/bin/bash

docker stop $(docker ps -q --filter ancestor=bingobongo )

docker build . -t bingobongo

 docker run -d -it -p 8022:8080 bingobongo