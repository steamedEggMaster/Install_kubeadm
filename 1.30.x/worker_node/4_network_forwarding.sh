cat << EOF | sudo tee /etc/sysctl.d/99-kubernetes.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
# net.bridge.bridge-nf-call-iptables  = 1
## : 브릿지 네트워크를 통해 들어오는 IPv4 패킷도, iptables 규칙을 거치도록 설정
##   => Pod 간 네트워크 Filtering 가능
# net.bridge.bridge-nf-call-ip6tables = 1
## : IPv6 용
# net.ipv4.ip_forward = 1	
## : IP Forwarding 활성화
##   => 노드가 Router처럼 패킷 전달
##   => Pod-to-Pod, Pod <-> 외부 통신 필수 설정

sudo sysctl --system
# /etc/sysctl.d/*.conf 모든 파일들을 읽어, 
# 시스템 커널 파라미터에 반영

sudo iptables -P FORWARD ACCEPT
# iptables의 FORWARD 체인의 기본 정책을 ACCEPT로 변경
# k8s에서는, Pod-to-Pod 통신이 다른 인터페이스를 통과하며, FORWARD 체인을 지남
# => DROP 정책이면 통신 불가!
## 확인 명령어 : sudo iptables -L