#!/usr/bin/env bash

. $1

. ./functions.sh

set -e

CERT_DIR=$TUTORIAL_HOME/assets/certs/generated

docker run -ti --rm -v $CERT_DIR:/certs --workdir /certs openjdk:15 keytool -importcert -noprompt -alias kafka  -file server.pem -keystore trusted.jks -storepass changeit

mv $CERT_DIR/trusted.jks .

#kubectl -n confluent cp kafka.properties kafka-0:/tmp/kafka.properties
#kubectl -n confluent cp trusted.jks kafka-0:/tmp/trusted.jks

#kubectl -n confluent exec -ti kafka-0 -- sh -c "KAFKA_OPTS='-Djavax.net.ssl.trustStore=/tmp/trusted.jks -Djavax.net.ssl.trustStorePassword=changeit' kafka-topics --bootstrap-server kafka-0.kafka.confluent.svc.cluster.local:9073 --command-config /tmp/kafka.properties --create --topic test --replication-factor 3 --partitions 10"

kubectl apply -f test-topic.yaml

kubectl create secret generic kafka-properties --from-file kafka.properties -n confluent
kubectl create secret generic kafka-truststore --from-file trusted.jks -n confluent


kubectl apply -f perf-test.yml

job_query(){
    kubectl -n confluent  get pods -l job-name=perf -o jsonpath="{.items[*].status.phase}"
}

wait_for_status "Running" job_query

kubectl -n confluent logs -f \
    $(kubectl -n confluent get pods -l job-name=perf -o jsonpath="{.items[*].metadata.name}")
