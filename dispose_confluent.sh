#!/usr/bin/env bash

. $1

./create_certificates.sh $1 

CLUSTER_CONF_DIR=$TUTORIAL_HOME/security/production-secure-deploy

echo Deleting API Key
api_key=$(cat telemetry.txt | grep ^api.key | sed "s/^.*=//")
confluent api-key delete $api_key
rm -f telemetry.txt


kubectl delete -f $CLUSTER_CONF_DIR/confluent-platform-production.yaml --namespace confluent
kubectl delete confluentrolebinding --all --namespace confluent
kubectl delete secret rest-credential ksqldb-mds-client sr-mds-client connect-mds-client krp-mds-client c3-mds-client mds-client ca-pair-sslcerts --namespace confluent
kubectl delete secret mds-token --namespace confluent
kubectl delete secret rest-credential --namespace confluent
kubectl delete secret ksqldb-mds-client --namespace confluent
kubectl delete secret sr-mds-client --namespace confluent
kubectl delete secret c3-mds-client --namespace confluent
kubectl delete secret connect-mds-client --namespace confluent
kubectl delete secret credential --namespace confluent
kubectl delete secret tls-group1 --namespace confluent
helm delete operator --namespace confluent

