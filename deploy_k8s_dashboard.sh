#!/usr/bin/env bash

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.1/aio/deploy/recommended.yaml
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
kubectl apply -f dashboard-adminuser-sa.yaml
kubectl apply -f dashboard-adminuser-crb.yaml

echo Token to provide to the dashboard:

kubectl -n kubernetes-dashboard create token admin-user

echo Copy the token displayed above ⬆️ ⬆️ ⬆️ , run kubectl proxy and open \
    http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
