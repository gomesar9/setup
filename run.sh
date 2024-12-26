#!/bin/bash

trap "docker compose down" EXIT

docker compose up -d

containerName="${PWD##*/}-cfg-test-1"
docker exec -it "$containerName" bash
