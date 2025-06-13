# course notes

`apk add curl` - add packages from inside a container

##

## kube-scheduler

schedules pods on nodes, responsible for deciding which pod goes on which node,
but does not place the pod on the node, the kubelet is responsible for
deployment.

to view options

- settings on a kubeadm deployment
  `/etc/kubernetes/manifest/kube-scheduler.yml`

- on none-kubeadm deployment
  `/etc/systemd/system/kube-scheduler.service`

-or using `ps waux | grep kube-scheduler`

## controller-manager

monitors various states of components in the kubernetes system and works towards
remediation there are many controllers in kubernetes

when installed the kube-controller-manager installed the various components it
needs to operate by default all controllers are enabled, however they can be
disabled on the controller-manager setup options

- settings on a kubeadm deployment
  `/etc/kubernetes/manifest/kube-controller-manager.yml`

- on none-kubeadm deployment
  `/etc/systemd/system/kube-controller-mananger.service`

-or using `ps waux | grep kube-controller-manager`

- Parent: kubernetes controller-manager
  - node-controller
  - deployment-controller
  - endpoint-controller
  - pvbinder-controller
  - namespace-controller
  - service-account-controller
  - job-controller etc

## view kube-api server options

- in kubeadm deployment

`/etc/kubernetes/manifest/kube-apiserver.yml`

- in none-kubeadm deployment

`/etc/systemd/system/kube-apiserver.service`

or query the process

`ps -aux | grep kube-apiserver`

## kubeapi server

- gets/stores data on the etcd server

## containerd (nerdctl)

docker like command for containerd

## ETCDCTL is the CLI tool used to interact with ETCD

etcdctl snapshot save
etcdctl endpoint health
etcdctl get
etcdctl put

```bash
kubectl exec etcd-master -n kube-system -- sh -c "ETCDCTL_API=3 etcdctl get / --prefix --keys-only --limit=10 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt  --key /etc/kubernetes/pki/etcd/server.key"
```

## critcl (same as docker or podman commnad)

used to inspect/troubleshoot container runtimes (not to deploy)

`crictl pods`
`critpl ps -a`
`crictl exec -it abababababababb ls`
`crictl logs abababababababb -f`
`crictl images`
`crictl info`
