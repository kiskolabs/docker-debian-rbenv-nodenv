#!/bin/bash

docker build . --tag kiskolabs/debian-rbenv-nodenv --no-cache
docker push kiskolabs/debian-rbenv-nodenv:latest

