#!/bin/bash

cat << EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
# overlay와 br_netfilter라는 커널 모듈 이름을 
# /etc/modules-load.d/k8s.conf(부팅 시 자동으로 Load할 커널 모듈 지정)에 저장 
## overlay : 컨테이너 이미지 계층을 파일시스템으로 사용가능케함
###        - Docker/Containerd에서 필수
## br_netfilter : Linux bridge를 통해 전달되는 패킷이 iptables를 통과 가능케함.
###        - k8s에서 Pod-to-Pod 통신에 필수

sudo modprobe overlay
sudo modprobe br_netfilter
# modprobe : 커널 모듈을 동적으로 로드
##         - 의존 모듈도 자동으로 함께 로드