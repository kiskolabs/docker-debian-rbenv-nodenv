#!/bin/bash

docker build . --tag amkisko/debian-rbenv-nodenv
docker push amkisko/debian-rbenv-nodenv:latest

