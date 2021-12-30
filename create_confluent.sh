#!/usr/bin/env bash

. $1

./create_certificates.sh $1 

CLUSTER_CONF_DIR=$TUTORIAL_HOME/security/production-secure-deploy

echo Creating API Key for Health+
confluent api-key create --resource cloud --description "For h+" -o json|jq --raw-output '"api.key=" + .key + ",api.secret=" + .secret'|sed "s/,/\n/" > telemetry.txt

kubectl create namespace confluent
kubectl config set-context --current --namespace confluent

kubectl create secret generic telemetry --from-file=telemetry.txt

helm repo add confluentinc https://packages.confluent.io/helm
helm upgrade --install operator confluentinc/confluent-for-kubernetes --set telemetry.enabled=true --set telemetry.secretRef=telemetry

helm upgrade --install -f $TUTORIAL_HOME/assets/openldap/ldaps-rbac.yaml test-ldap $TUTORIAL_HOME/assets/openldap --namespace confluent

kubectl create secret generic tls-group1 \
  --from-file=fullchain.pem=$TUTORIAL_HOME/assets/certs/generated/server.pem \
  --from-file=cacerts.pem=$TUTORIAL_HOME/assets/certs/generated/ca.pem \
  --from-file=privkey.pem=$TUTORIAL_HOME/assets/certs/generated/server-key.pem \
  --namespace confluent

kubectl create secret generic credential \
 --from-file=plain-users.json=$CLUSTER_CONF_DIR/creds-kafka-sasl-users.json \
 --from-file=digest-users.json=$CLUSTER_CONF_DIR/creds-zookeeper-sasl-digest-users.json \
 --from-file=digest.txt=$CLUSTER_CONF_DIR/creds-kafka-zookeeper-credentials.txt \
 --from-file=plain.txt=$CLUSTER_CONF_DIR/creds-client-kafka-sasl-user.txt \
 --from-file=basic.txt=$CLUSTER_CONF_DIR/creds-control-center-users.txt \
 --from-file=ldap.txt=$CLUSTER_CONF_DIR/ldap.txt

kubectl create secret generic mds-token \
  --from-file=mdsPublicKey.pem=$TUTORIAL_HOME/assets/certs/mds-publickey.txt \
  --from-file=mdsTokenKeyPair.pem=$TUTORIAL_HOME/assets/certs/mds-tokenkeypair.txt

# Kafka RBAC credential
kubectl create secret generic mds-client \
  --from-file=bearer.txt=$CLUSTER_CONF_DIR/bearer.txt
# Control Center RBAC credential
kubectl create secret generic c3-mds-client \
  --from-file=bearer.txt=$CLUSTER_CONF_DIR/c3-mds-client.txt
# Connect RBAC credential
kubectl create secret generic connect-mds-client \
  --from-file=bearer.txt=$CLUSTER_CONF_DIR/connect-mds-client.txt
# Schema Registry RBAC credential
kubectl create secret generic sr-mds-client \
  --from-file=bearer.txt=$CLUSTER_CONF_DIR/sr-mds-client.txt
# ksqlDB RBAC credential
kubectl create secret generic ksqldb-mds-client \
  --from-file=bearer.txt=$CLUSTER_CONF_DIR/ksqldb-mds-client.txt
# Kafka REST credential
kubectl create secret generic rest-credential \
  --from-file=bearer.txt=$CLUSTER_CONF_DIR/bearer.txt \
  --from-file=basic.txt=$CLUSTER_CONF_DIR/bearer.txt

kubectl apply -f $CLUSTER_CONF_DIR/confluent-platform-production.yaml
kubectl apply -f $CLUSTER_CONF_DIR/controlcenter-testadmin-rolebindings.yaml
