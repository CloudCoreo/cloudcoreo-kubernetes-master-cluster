cloudcoreo-kubernetes-master-cluster
=====================================


## Description
This repository is the [CloudCoreo](https://www.cloudcoreo.com) stack for kubernetes master.

This stack will add a scalable, highly availabe, self healing kubernetes master cluster environment based on the [CloudCoreo leader election cluster here](http://hub.cloudcoreo.com/stack/leader-elect-cluster&#95;35519).

Kubernetes allows you to manage a cluster of Linux containers as a single system to accelerate Dev and simplify Ops. The architecture is such that master and node clusters are both required. This is only the cluster for the master. This cluster expects an etcd cluster as well. If you need an etcd cluster there is one available [on the hub, here.](http://hub.cloudcoreo.com/stack/etcd-cluster&#95;06252)

Interestingly there is no leader election with the kubernetes master. The requests are load balanced and the cluster exists simply for high availability. The durability is maintained by etcd.

Default values will result in a 2 datacenter deployment behind an internal load balancer addressable via a DNS record. 


## Hierarchy
![composite inheritance hierarchy](https://raw.githubusercontent.com/CloudCoreo/cloudcoreo-kubernetes-master-cluster/master/images/hierarchy.png "composite inheritance hierarchy")



## Required variables with no default

### `KUBE_CLUSTER_AMI`:
  * description: the ami to launch for the cluster - default is Amazon Linux AMI 2015.03 (HVM), SSD Volume Type


## Required variables with default

### `KUBE_VERSION`:
  * description: kubernetes version
  * default: 1.1.4

### `KUBE_MASTER_SERVICE_IP_CIDRS`:
  * description: kubernetes service cidrs
  * default: 10.1.1.0/24


### `VPC_NAME`:
  * description: the name of the VPC
  * default: kube-dev


### `VPC_CIDR`:
  * description: the cloudcoreo defined vpc to add this cluster to
  * default: 10.1.0.0/16

### `PRIVATE_SUBNET_NAME`:
  * description: the cloudcoreo name of the private vpc subnets. eg private-us-west-2c
  * default: kube-dev-private-us-west-1

### `PRIVATE_ROUTE_NAME`:
  * description: the private subnet in which the cluster should be added
  * default: dev-private-route

### `DNS_ZONE`:
  * description: the zone in which the internal elb dns entry should be maintained
  * default: dev.aws.lcloud.com

### `ETCD_DNS_ZONE`:
  * description: the zone in which the internal elb dns entry should be maintained
  * default: dev.aws.lcloud.com

### `KUBE_MASTER_NAME`:
  * description: the name of the cluster - this will become your dns record too
  * default: kube-master

### `ETCD_CLUSTER_NAME`:
  * description: the dns record of the etcd cluster
  * default: dev-etcd

### `KUBE_MASTER_ELB_TRAFFIC_PORTS`:
  * description: ports that need to allow traffic into the ELB
  * default: 1f90

### `KUBE_MASTER_ELB_TRAFFIC_CIDRS`:
  * description: the cidrs to allow traffic from on the ELB itself
  * default: 10.0.0.0/8

### `KUBE_MASTER_TCP_HEALTH_CHECK_PORT`:
  * description: a tcp port the ELB will check every so often - this defines health and ASG termination
  * default: 10251

### `KUBE_MASTER_INSTANCE_TRAFFIC_PORTS`:
  * description: ports to allow traffic on directly to the instances
  * default: 1..65535

### `KUBE_MASTER_INSTANCE_TRAFFIC_CIDRS`:
  * description: cidrs that are allowed to access the instances directly
  * default: 10.0.0.0/8

### `KUBE_MASTER_SIZE`:
  * description: the image size to launch
  * default: t2.small


### `KUBE_MASTER_HEALTH_CHECK_GRACE_PERIOD`:
  * description: the time in seconds to allow for instance to boot before checking health
  * default: 600

### `KUBE_MASTER_UPGRADE_COOLDOWN`:
  * description: the time in seconds between rolling instances during an upgrade
  * default: 300

### `TIMEZONE`:
  * description: the timezone the servers should come up in
  * default: America/LosAngeles


### `KUBE_MASTER_KEY`:
  * description: the ssh key to associate with the instance(s) - blank will disable ssh
  * default: cloudops


## Optional variables with no default

### `WAIT_FOR_ETCD`:
  * description: should we wait for etcd or just continue?
  * default: true

### `KUBE_ALLOW_PRIVILEGED`:
  * description: allow privileged containers
  * default: true

### `KUBE_API_LOG_FILE`:
  * description: ha-nat log file
  * default: /var/log/kube-apiserver.log


### `KUBE_CONTROLLER_MANAGER_LOG_FILE`:
  * description: ha-nat log file
  * default: /var/log/kube-controller-manager.log


### `KUBE_SCHEDULER_LOG_FILE`:
  * description: ha-nat log file
  * default: /var/log/kube-scheduler.log


### `KUBE_PROXY_LOG_FILE`:
  * description: ha-nat log file
  * default: /var/log/kube-api.log


### `KUBE_MASTER_ELB_LISTENERS`:
  * description: The listeners to apply to the ELB
  * default: 
```
[
  {
      :elb_protocol => 'tcp',
      :elb_port => 8080,
      :to_protocol => 'tcp',
      :to_port => 8080
  }
]

```

### `DATADOG_KEY`:
  * description: If you have a datadog key, enter it here and we will install the agent
  * default: 


### `WAIT_FOR_KUBE_MASTER_MIN`:
  * description: true if the cluster should wait for all instances to be in a running state
  * default: true


## Optional variables with default

### `VPC_SEARCH_TAGS`:
  * description: if you have more than one VPC with the same CIDR, and it is not under CloudCoreo control, we need a way to find it. Enter some unique tags that exist on the VPC you want us to find. ['env=production','Name=prod-vpc']

### `PRIVATE_ROUTE_SEARCH_TAGS`:
  * description: if you more than one route table or set of route tables, and it is not under CloudCoreo control, we need a way to find it. Enter some unique tags that exist on your route tables you want us to find. i.e. ['Name=my-private-routetable','env=dev']

### `PRIVATE_SUBNET_SEARCH_TAGS`:
  * description: Usually the private-routetable association is enough for us to find the subnets you need, but if you have more than one subnet, we may need a way to find them. unique tags is a great way. enter them there. i.e. ['Name=my-private-subnet']

## Tags
1. Container Management
1. Google
1. Kubernetes
1. High Availability
1. Master
1. Cluster

## Categories
1. Servers



## Diagram
![diagram](https://raw.githubusercontent.com/CloudCoreo/cloudcoreo-kubernetes-master-cluster/master/images/diagram.png "diagram")


## Icon


