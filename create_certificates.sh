#!/usr/bin/env bash

set -e

. $1

CERTS_HOME=$TUTORIAL_HOME/assets/certs

if [ -d $CERTS_HOME/generated ] 
then
	echo Assuming certificates are already generated, doing nothing
	exit 0
fi

mkdir $CERTS_HOME/generated

openssl genrsa -out $CERTS_HOME/generated/rootCAkey.pem 2048

openssl req -x509  -new -nodes \
  -key $CERTS_HOME/generated/rootCAkey.pem \
  -days 3650 \
  -out $CERTS_HOME/generated/cacerts.pem \
  -subj "/C=US/ST=CA/L=MVT/O=TestOrg/OU=Cloud/CN=TestCA"

# Create Zookeeper server certificates
# Use the SANs listed in zookeeper-server-domain.json

cfssl gencert -ca=$CERTS_HOME/generated/cacerts.pem \
-ca-key=$CERTS_HOME/generated/rootCAkey.pem \
-config=$CERTS_HOME/component-certs/ca-config.json \
-profile=server $CERTS_HOME/component-certs/zookeeper-server-domain.json | cfssljson -bare $CERTS_HOME/generated/zookeeper-server

# Create Kafka server certificates
# Use the SANs listed in kafka-server-domain.json

cfssl gencert -ca=$CERTS_HOME/generated/cacerts.pem \
-ca-key=$CERTS_HOME/generated/rootCAkey.pem \
-config=$CERTS_HOME/component-certs/ca-config.json \
-profile=server $CERTS_HOME/component-certs/kafka-server-domain.json | cfssljson -bare $CERTS_HOME/generated/kafka-server

# Create ControlCenter server certificates
# Use the SANs listed in controlcenter-server-domain.json

cfssl gencert -ca=$CERTS_HOME/generated/cacerts.pem \
-ca-key=$CERTS_HOME/generated/rootCAkey.pem \
-config=$CERTS_HOME/component-certs/ca-config.json \
-profile=server $CERTS_HOME/component-certs/controlcenter-server-domain.json | cfssljson -bare $CERTS_HOME/generated/controlcenter-server

# Create SchemaRegistry server certificates
# Use the SANs listed in schemaregistry-server-domain.json

cfssl gencert -ca=$CERTS_HOME/generated/cacerts.pem \
-ca-key=$CERTS_HOME/generated/rootCAkey.pem \
-config=$CERTS_HOME/component-certs/ca-config.json \
-profile=server $CERTS_HOME/component-certs/schemaregistry-server-domain.json | cfssljson -bare $CERTS_HOME/generated/schemaregistry-server

# Create Connect server certificates
# Use the SANs listed in connect-server-domain.json

cfssl gencert -ca=$CERTS_HOME/generated/cacerts.pem \
-ca-key=$CERTS_HOME/generated/rootCAkey.pem \
-config=$CERTS_HOME/component-certs/ca-config.json \
-profile=server $CERTS_HOME/component-certs/connect-server-domain.json | cfssljson -bare $CERTS_HOME/generated/connect-server

# Create ksqlDB server certificates
# Use the SANs listed in ksqldb-server-domain.json

cfssl gencert -ca=$CERTS_HOME/generated/cacerts.pem \
-ca-key=$CERTS_HOME/generated/rootCAkey.pem \
-config=$CERTS_HOME/component-certs/ca-config.json \
-profile=server $CERTS_HOME/component-certs/ksqldb-server-domain.json | cfssljson -bare $CERTS_HOME/generated/ksqldb-server
