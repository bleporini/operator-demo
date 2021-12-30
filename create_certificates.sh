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

cfssl gencert -initca $TUTORIAL_HOME/assets/certs/ca-csr.json | \
	cfssljson -bare $TUTORIAL_HOME/assets/certs/generated/ca -

# Create server certificates with the appropriate SANs (SANs listed in server-domain.json)
cfssl gencert -ca=$TUTORIAL_HOME/assets/certs/generated/ca.pem \
-ca-key=$TUTORIAL_HOME/assets/certs/generated/ca-key.pem \
-config=$TUTORIAL_HOME/assets/certs/ca-config.json \
-profile=server $TUTORIAL_HOME/assets/certs/server-domain.json | cfssljson -bare $TUTORIAL_HOME/assets/certs/generated/server

