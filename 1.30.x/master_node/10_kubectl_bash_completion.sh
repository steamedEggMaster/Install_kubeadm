#!/bin/bash

source <(kubectl completion bash)
kubectl completion bash > ~/.kube/completion.bash.inc

printf "
# kubectl shell completion
source '$HOME/.kube/completion.bash.inc'
" >> $HOME/.bash_aliases

source $HOME/.bash_aliases