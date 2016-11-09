This repository is the [CloudCoreo](https://www.cloudcoreo.com) stack for kubernetes master.

This stack will add a scalable, highly availabe, self healing kubernetes master cluster environment based on the [CloudCoreo leader election cluster here](http://hub.cloudcoreo.com/stack/leader-elect-cluster_35519).

Kubernetes allows you to manage a cluster of Linux containers as a single system to accelerate Dev and simplify Ops. The architecture is such that master and node clusters are both required. This is only the cluster for the master. This cluster expects an etcd cluster as well. If you need an etcd cluster there is one available [on the hub, here.](http://hub.cloudcoreo.com/stack/etcd-cluster_06252)

Interestingly there is no leader election with the kubernetes master. The requests are load balanced and the cluster exists simply for high availability. The durability is maintained by etcd.

Default values will result in a 2 datacenter deployment behind an internal load balancer addressable via a DNS record. 
