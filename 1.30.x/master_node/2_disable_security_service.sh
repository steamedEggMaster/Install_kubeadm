#!/bin/bash

sudo systemctl stop ufw
sudo systemctl disable ufw
## ufw(Uncomplicated Firewall) : Ubuntu의 기본 방화벽
## Node간 통신에 방화벽이 방해가 되지 않기위해 종료
sudo systemctl stop apparmor.service
sudo systemctl disable apparmor.service
## AppArmor : 리눅스의 프로세스별 접근 제어 보안 모듈
## 특정 바이너리 or 서비스가 시스템 리소스에 접근하는 것 제한.
## => 제약을 없애기 위해 종료
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
## 부팅시 Swap 자동 마운트 방지
sudo swapoff -a
## Kubernetes가 노드에 자원할당을 정확하게 수행하기 위해 종료