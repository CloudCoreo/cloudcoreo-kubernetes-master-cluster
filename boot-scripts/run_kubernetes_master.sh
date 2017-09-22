#!/bin/bash
######################################################################
#
# VARIABLES:
#   KUBE_VERSION = 1.0.6
#   KUBE_MASTER_NAME =
#   DNS_ZONE = dev.aws.lcloud.com
#   ETCD_CLUSTER_NAME = dev-etcd
#   ETCD_DNS_ZONE = dev.aws.lcloud.com
#   KUBE_CLUSTER_IP_CIDR = 10.1.1.0/24
#   KUBE_ALLOW_PRIVILEGED = true
#   KUBE_API_LOG_FILE = /var/log/kube-apiserver.log
#   KUBE_CONTROLLER_MANAGER_LOG_FILE = /var/log/kube-controller-manager.log
#   KUBE_SCHEDULER_LOG_FILE = /var/log/kube-scheduler.log
#   KUBE_PROXY_LOG_FILE = /var/log/kube-proxy.log
#
# PORTS:
#     kube-apiserver = 8080, 6443 (TLS)
#######################################################################

## this stack extends the leader elect cluster, so lets source in the cluster profile and expose some variables to us
source /etc/profile.d/cluster

echo "running kubernetes"

kube_dir="/opt/kubernetes"
sup_conf="/etc/supervisord.conf"

(

    cd "$kube_dir"
    name="$(echo $MY_IPADDRESS | perl -pe 's{\.}{}g')"

    if ! cat "$sup_conf" | grep -q "program:kube-apiserver"; then
	cat <<EOF >> "$sup_conf"
[program:kube-apiserver]
redirect_stderr=true
stdout_logfile=${KUBE_API_LOG_FILE}
stdout_logfile_maxbytes=50MB

command=/bin/bash -c '$kube_dir/kube-apiserver \
                          --admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ResourceQuota \
                          --etcd_servers=http://${ETCD_CLUSTER_NAME}.${DNS_ZONE}:2379  \
                          --insecure-bind-address=0.0.0.0 \
                          --service-cluster-ip-range=${KUBE_MASTER_SERVICE_IP_CIDRS} \
                          --allow-privileged=true \
                          --v=2 \
                          '
EOF
    fi
    if ! cat "$sup_conf" | grep -q "program:kube-controller-manager"; then
	cat <<EOF >> "$sup_conf"
[program:kube-controller-manager]
redirect_stderr=true
stdout_logfile=${KUBE_CONTROLLER_MANAGER_LOG_FILE}
stdout_logfile_maxbytes=50MB

command=/bin/bash -c '$kube_dir/kube-controller-manager \
                          --master=http://${KUBE_MASTER_NAME}.${DNS_ZONE}:8080 \
                          --v=2 \
                          '
EOF
    fi
    if ! cat "$sup_conf" | grep -q "program:kube-scheduler"; then
	cat <<EOF >> "$sup_conf"
[program:kube-scheduler]
redirect_stderr=true
stdout_logfile=${KUBE_SCHEDULER_LOG_FILE}
stdout_logfile_maxbytes=50MB

command=/bin/bash -c '$kube_dir/kube-scheduler \
                          --master=http://${KUBE_MASTER_NAME}.${DNS_ZONE}:8080 \
                          --address=${MY_IPADDRESS} \
                          --v=2 \
                          '
EOF
    fi
    if ! cat "$sup_conf" | grep -q "program:kube-proxy"; then
	cat <<EOF >> "$sup_conf"

[program:kube-proxy]
redirect_stderr=true
stdout_logfile=${KUBE_PROXY_LOG_FILE}
stdout_logfile_maxbytes=50MB
command=/bin/bash -c '$kube_dir/kube-proxy \\
                        --v=2 \\
                        --master="http://${KUBE_MASTER_NAME}.${DNS_ZONE}:8080" \\
                        '
EOF
    fi
    supervisord

)
