#!/bin/bash

set -e

# generate a new key
openssl genrsa -out andrew.key 4096

# 02 create csr
openssl req -config ./csr.cnf -new -key andrew.key -nodes -out andrew.csr

# encode .csr
export BASE64_CSR=$(cat ./andrew.csr | base64 | tr -d '\n')

# create csr resource
kubectl delete csr mycsr || true
cat csr.yaml | envsubst | kubectl apply -f -

# check status of newly created csr
kubectl get csr

# approve csr
kubectl certificate approve mycsr

# check status again. Should be approved
kubectl get csr

# certificate is created. extract from csr and save in file
kubectl get csr mycsr -o jsonpath='{.status.certificate}' \
  | base64 --decode > andrew.crt


# creation of the role
kubectl create ns development || true

kubectl apply -f role.yaml
kubectl apply -f rolebinding-user.yaml


# User identifier
export USER="andrew"

CURRENT_CONTEXT=$(kubectl config current-context)

export CURRENT_CLUSTER_NAME=$(kubectl config view --raw -o json | \
  jq -r --arg CURRENT_CONTEXT "${CURRENT_CONTEXT}" \
  '.contexts[] | select(.name == $CURRENT_CONTEXT) | .context.cluster')

export CURRENT_CLUSTER=$(kubectl config view --raw -o json | \
  jq -r --arg NAME "${CURRENT_CLUSTER_NAME}" \
  ' .clusters[] | select(.name == $NAME) | .cluster ' )


# Cluster Certificate Authority
export CLUSTER_CA=$(echo $CURRENT_CLUSTER | jq -r '."certificate-authority-data"')

# Client certificate
export CLIENT_CERTIFICATE_DATA=$(kubectl get csr mycsr -o jsonpath='{.status.certificate}')

# API Server endpoint
export CLUSTER_ENDPOINT=$(echo $CURRENT_CLUSTER | jq -r '.server')

cat kubeconfig.tpl | envsubst > new-kubeconfig

KUBECONFIG=./new-kubeconfig kubectl config set-credentials andrew \
  --client-key=$PWD/andrew.key \
  --embed-certs=true
