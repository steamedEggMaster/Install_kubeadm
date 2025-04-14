#!/bin/bash

mkdir -p ~/kubeadm && cd ~/kubeadm

#-----------------------------------------------
# kubernetes 다운로드 key 와 url 등록
#-----------------------------------------------
KUBE_VERSION="v1.30"
curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBE_VERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# kubernetes 패키지 검증을 위한 GPG 키 등록
# .gpg로 변환하여 APT가 사용 가능케 함

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# Kubernetes 공식 API 저장소 URL 추가
sudo apt-get update


#========================================================================
# kubelet 설치 (아직 kubelet 이 뜨지는 않음)
#========================================================================
KUBE_TOOL_VERSION="1.30.3-*"
sudo apt-get install -y kubelet="${KUBE_TOOL_VERSION}" kubeadm="${KUBE_TOOL_VERSION}"
sudo systemctl enable --now kubelet
sudo systemctl start kubelet

#========================================================================
# 1. kubeadm 설치
#========================================================================
sudo kubeadm config images pull
# k8s 초기화 시 필요한 컨테이너 이미지들(Control Plain 구성 요소들) 다운로드
# kube-apiserver, kube-controller-manager, kube-scheduler, 
# kube-proxy, etcd, coredns, pause

#------------------------------------------------------------
# 자기 노드의 ip: --apiserver-advertise-address
# multi control-plane 일 경우 L4 ip: --control-plane-endpoint
# cgroup driver 세팅 (https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/)
#------------------------------------------------------------
NODE_PRIVATE_IP=$(hostname -I | awk '{print $1}')
NODE_PUBLIC_IP=$(curl -s ifconfig.me)
cat <<EOF | sudo tee kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
nodeRegistration:
  criSocket: "/var/run/containerd/containerd.sock"

---
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
apiServer:
  certSANs:
  - 127.0.0.1
  - localhost
  - ${NODE_PRIVATE_IP}
  - ${NODE_PUBLIC_IP}
networking:
  serviceSubnet: 10.233.0.0/18
  podSubnet: 10.233.64.0/18
  dnsDomain: "cluster.local"
EOF
# certSANs : API Server 접근 허용 주소
# serviceSubnet : ClusterIP 주소 대역
# podSubnet : Pod 네트워크 대역 - CNI 플러그인의 설정과 일치해야함!
## 

#----------------------------------------------------------------
# kubeadm init 을 하고 나면 /var/lib/kubelet/config.yaml 이 생성되어
# kubelet 이 정상적으로 실행됨
#----------------------------------------------------------------
sudo kubeadm init --config kubeadm-config.yaml --v=5
# Control Plain 초기화
# --v=5 : 로그 출력 수준 높임


#------------------------------------------------------------
# kubeconfig
#------------------------------------------------------------
mkdir -p ~/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
# 현재 사용자가 사용하는 kubectl이 클러스터에 접속할 수 있도록 설정