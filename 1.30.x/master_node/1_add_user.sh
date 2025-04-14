sudo adduser ask ## 유저 추가

## -------------------------------------------------------
## ask 사용자에게 비밀번호없이 sudo 명령어를 허용하는 설정
## -------------------------------------------------------
cat << EOF | sudo tee /etc/sudoers.d/sudoers-ask
ask     ALL=(ALL:ALL)   NOPASSWD:ALL
EOF
# cat << EOF ~ EOF : 입력된 내용을 표준 출력으로 내보냄
##  => ask     ALL=(ALL:ALL)   NOPASSWD:ALL 를 출력함
# sudo tee /etc/sudoers.d/sudoers-ask
## tee : 입력받은 내용을 파일로 저장하면서, 동시에 출력
## ask에게 ALL(어떤 호스트에서든) ALL:ALL(어떤 사용자든, 어떤 그룹으로든 sudo 실행 가능)
## NOPASSWD:ALL(sudo 명령 사용 시 비밀번호 묻지 않음)