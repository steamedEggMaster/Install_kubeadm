sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
# apt-transport-https : HTTPS를 통해 APT 저장소 사용 가능
# ca-certificates : 인증서 사용을 위함
# gpg(GNU Privacy Guard) : 디지털 서명 검증

sudo install -m 0755 -d /etc/apt/keyrings
# Docker GPG 키 저장할 /etc/apt/keyrings 생성
# 0755 : 읽기/실행 권한을 대부분에게 주는 일반 디렉터리 권한
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
# Docker 공식 GPG 키를 받아, 폴더에 저장
sudo chmod a+r /etc/apt/keyrings/docker.asc
# APT가 서명된 패키지를 검증 가능하도록 읽기 권한 부여

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
## dpkg --print-architecture : 현재 시스템 아키텍쳐
## $(. /etc/os-release && echo "$VERSION_CODENAME") : 현재 Ubuntu의 버전 코드네임
# Docker 패키지 저장소를 APT에 등록
# Docker 저장소에서 Containerd 패키지를 설치 가능케함

sudo apt-get update
sudo apt-get install -y containerd.io
# 해당 Docker 저장소에서 Containerd 런타임 설치

sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
# 기본 설정파일을 /etc/containerd/config.toml에 생성

sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
# k8s는 systemd를 CGroup 드라이버로 사용을 권장
# => containerd가 cgroupfs 대신, systemd로 사용하도록 변경
## kubelet과 같은 설정을 써야 리소스 관리 충돌 안생김!!

sudo systemctl restart containerd
sudo systemctl enable containerd
# sudo systemctl status containerd