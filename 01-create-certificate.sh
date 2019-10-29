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
