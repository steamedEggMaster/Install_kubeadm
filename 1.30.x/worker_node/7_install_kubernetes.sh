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