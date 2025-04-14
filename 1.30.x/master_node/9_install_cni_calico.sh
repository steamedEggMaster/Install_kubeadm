#!/bin/bash

mkdir -p ~/calico && cd ~/calico

CALICO_VERSION="v3.28.0"
## Kubernetes v1.30 버전과 호환됨
curl -LO https://raw.githubusercontent.com/projectcalico/calico/${CALICO_VERSION}/manifests/tigera-operator.yaml
kubectl create -f tigera-operator.yaml

curl -LO https://raw.githubusercontent.com/projectcalico/calico/${CALICO_VERSION}/manifests/custom-resources.yaml
#------------------------------------------------------------
# yaml 을 열어서 pod 네트워크를 확인하고 변경
#------------------------------------------------------------
POD_CIDR="10.233.64.0/18"
sed -i "s|cidr:.*|cidr: ${POD_CIDR}|" custom-resources.yaml
kubectl create -f custom-resources.yaml

#------------------------------------------------------------
# calico 설치 확인
#------------------------------------------------------------
kubectl get pods -n calico-system