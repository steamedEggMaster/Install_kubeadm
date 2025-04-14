#!/bin/bash

VERSION="v1.30.0"
ARCH="amd64"
curl -LO "https://dl.k8s.io/release/${VERSION}/bin/linux/${ARCH}/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
# kubectl(Kubernetes Control)

kubectl version --client
# 정상 다운로드 확인