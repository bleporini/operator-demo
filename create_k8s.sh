#!/usr/bin/env bash

. $1

gcloud config set project $GCP_PROJECT
gcloud config set compute/region $GCP_REGION

gcloud container clusters create $CLUSTER_NAME --region $GCP_REGION --num-nodes=$K8S_NODES --labels=k8s_cluster=$CLUSTER_NAME

gcloud container clusters get-credentials $CLUSTER_NAME --region $GCP_REGION
