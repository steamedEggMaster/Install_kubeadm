#!/bin/bash

VERSION="v1.30.0"
ARCH="amd64"

curl -L https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-${VERSION}-linux-${ARCH}.tar.gz --output crictl-${VERSION}-linux-${ARCH}.tar.gz

sudo tar zxvf crictl-$VERSION-linux-${ARCH}.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-${ARCH}.tar.gz
# crictl(Container Runtime Interface Control) 
# : Containerd와 같은 컨테이너 런타임과 직접 통신 가능한 커맨드라인 도구
## - docker cli라고 생각하면됨(docker가 아닌 containerd이기에 crictl 사용)

# -C /usr/local/bin : 어디서든 crictl 실행가능하도록 해당 디렉토리에 압축 해제
# 명령어 종류 : crictl ps | pods | images | inspect | logs | exec | info

#----------------------------------------------------------
# crictl 이 어느 container 를 접속할 것인지 세팅
# 이거 없으면 매번 crictl 실행 시, 사용한 소켓 옵션을 지정해야함
#----------------------------------------------------------
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
debug: false
pull-image-on-create: false
EOF
# runtime-endpoint : containerd와 통신할 UNIX 소켓 주소
##                   => Container Runtime의 gRPC 서버 주소
# image-endpoint : 이미지 관련 요청을 보낼 소켓 주소
# timeout(초단위)
# debug : true면 내부 디버그 로그 출력
# pull-image-on-create : 컨테이너 생성 시, 이미지 자동 pull 여부
##                     - false로 수동 관리 선호

sudo bash -c "crictl completion > /etc/bash_completion.d/crictl"
# crictl 명령어에 대해 Tab 자동완성 기능 추가
source ~/.bashrc
# .bashrc를 다시 불러와서 파일의 내용을 현재 셀 세션에 적용


#----------------------------------------------------------
# containerd 설정 확인
#----------------------------------------------------------
sudo crictl info
