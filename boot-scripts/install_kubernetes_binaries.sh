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

    if echo $KUBE_VERSION | grep -q ^v ; then 
	echo "no modification necessary - KUBE_VERSION=${KUBE_VERSION}" 
    else 
	echo "modification necessary - KUBE_VERSION=${KUBE_VERSION} but should = v${KUBE_VERSION}" 
	KUBE_VERSION="v${KUBE_VERSION}"
    fi

    curl -L "https://github.com/kubernetes/kubernetes/releases/download/${KUBE_VERSION}/kubernetes.tar.gz" -o "kubernetes.tar.gz"

    rm -rf kubernetes/
    tar xzvf "kubernetes.tar.gz"

    if [ -f "kubernetes/cluster/get-kube-binaries.sh" ]; then
	( echo yes | sh -x "kubernetes/cluster/get-kube-binaries.sh" )
    fi

    tar xzvf kubernetes/server/kubernetes-server-linux-amd64.tar.gz -C "$kube_dir/build"
    cp $kube_dir/build/kubernetes/server/bin/* $kube_dir/
    #rm -rf $kube_dir/build
)
