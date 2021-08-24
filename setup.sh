#!/usr/bin/env bash
set -e
#set -x

. ./functions.sh

usage(){
    echo "./setup.sh <configuration file>"
    echo Expected variables are :
    echo GCP_PROJECT: GCP Project where the resources will be provisioned
    echo GCP_REGION: Region where the resources will be located
    echo CLUSTER_NAME: Name of the k8s cluster to create
    echo TUTORIAL_HOME: The directory where https://github.com/confluentinc/confluent-kubernetes-examples has been cloned
}

if [ -z "$1" ] && [ ! -e "$1" ] || [ ! -r "$1" ]
then
    >&2 echo Please provide a configuration file
    usage
    exit -1
fi

. $1

if [ -z "$GCP_PROJECT" ] || [ -z "$GCP_REGION" ] || [ -z "$CLUSTER_NAME" ] || [ -z "$TUTORIAL_HOME" ] 
then
    >&2 echo Please check configuration variables
    usage
    exit -1
fi

echo Variables:
echo CLUSTER_NAME= $CLUSTER_NAME
echo GCP_PROJECT= $GCP_PROJECT
echo GCP_REGION= $GCP_REGION
echo TUTORIAL_HOME= $TUTORIAL_HOME

./create_k8s.sh $1

./create_confluent.sh $1





