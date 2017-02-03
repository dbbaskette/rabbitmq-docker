#!/usr/bin/env bash

docker network create rabbit-net

docker run -d --hostname rabbit1 --name rabbit1 --net rabbit-net --net-alias=rabbit1 -v $PWD/scripts:/scripts -e RABBITMQ_ERLANG_COOKIE="docker-cluster" -p 4369:4369 -p 15672:15672 -p 5672:5672 rabbitmq:management
docker run -d --hostname rabbit2 --name rabbit2 --net rabbit-net --net-alias=rabbit2 -v $PWD/scripts:/scripts -e RABBITMQ_ERLANG_COOKIE="docker-cluster" -p 4370:4369 -p 15673:15672 -p 5673:5672 rabbitmq:management

sleep 5
docker exec -it rabbit1 /scripts/create-rabbit-user.sh
docker exec -it rabbit2 /scripts/create-rabbit-user.sh
docker exec -t rabbit2 /scripts/cluster-join.sh