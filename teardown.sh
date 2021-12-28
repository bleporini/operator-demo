#!/usr/bin/env bash
set -e
. $1

echo Disposing k8s cluster
gcloud container clusters delete $CLUSTER_NAME --region $GCP_REGION -q

echo Removing generated truststore
rm -f trusted.jks

echo Disposing disks
gcloud compute disks list --filter=labels.k8s_cluster=$CLUSTER_NAME --format="json"| \
    jq '.[] | "gcloud compute disks delete -q " + .name + " --zone " + .zone' --raw-output|sh

echo Deleting API Key
api_key=$(cat telemetry.txt | grep ^api.key | sed "s/^.*=//")
confluent api-key delete $api_key
rm -f telemetry.txt

echo Resetting all changes in the $TUTORIAL_HOME directory
cd $TUTORIAL_HOME
git reset --hard
