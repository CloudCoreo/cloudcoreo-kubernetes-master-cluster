#!/bin/bash
######################################################################
#
# VARIABLES:
#   KUBE_VERSION = 1.0.6
#
#######################################################################

echo "installing kubernetes binaries"

kube_dir="/opt/kubernetes"
rm -rf "$kube_dir"
mkdir -p "$kube_dir/build"
(
    cd /tmp
    rm -f "kubernetes.tar.gz"

    if [ -f "kubernetes/cluster/get-kube-binaries.sh" ]; then
	( echo yes | sh -x "kubernetes/cluster/get-kube-binaries.sh" )
    else
        curl -L "https://github.com/kubernetes/kubernetes/releases/download/v${KUBE_VERSION}/kubernetes.tar.gz" -o "kubernetes.tar.gz"
        rm -rf kubernetes/
        tar xzvf "kubernetes.tar.gz"
    fi

    tar xzvf kubernetes/server/kubernetes-server-linux-amd64.tar.gz -C "$kube_dir/build"
    cp $kube_dir/build/kubernetes/server/bin/* $kube_dir/
    #rm -rf $kube_dir/build
)
