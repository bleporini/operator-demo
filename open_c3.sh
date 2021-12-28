#!/usr/bin/env bash

url=$(kubectl get services/controlcenter-bootstrap-lb -o json|jq --raw-output '"https://" + .status.loadBalancer.ingress[0].ip')

open $url
