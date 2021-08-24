#!/usr/bin/env bash

. ./functions.sh

kubectl -n confluent exec -ti \
    $(kubectl -n confluent get pods -l job-name=perf -o jsonpath="{.items[*].metadata.name}") -- watch kafka-topics --bootstrap-server kafka.confluent.svc.cluster.local:9073 --command-config /conf/kafka.properties --describe --topic test

