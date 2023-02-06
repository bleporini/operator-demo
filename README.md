# Provisionner scripts to spin up a fully secured  Confluent For Kubernetes in an on purpose created GKE cluster

## Prerequisites

- `git`
- `kubectl`
- `gcloud` CLI
- `confluent` logged in (you can use `confluent login --save` one for all)
- docker

## Procedure

- Checkout https://github.com/confluentinc/confluent-kubernetes-examples
- Create a configuration file with the following variables:
```
CLUSTER_NAME=<the k8s cluster name>
GCP_PROJECT=<the project id to host the cluster>
GCP_REGION=<target region>
TUTORIAL_HOME=<path to the confluent-kubernetes-example cloned repository>
K8S_NODES=15
```
- Then run `./setup.sh <your environement variable file>`. It will create a k8s cluster, will generate a demo CA to issue all certificates, insall the Confluent Operator and provision a fully secured Confluent Platform instance

`./deploy_k8s_dashboard.sh` installs a k8s dashboard to provide a web user interface.

`./start-perf.sh <your environement variable file>` starts a `producer-perf-test` against the cluster.

`./teardown.sh <your environement variable file>` disposes the k8s cluster and removes all disks.


