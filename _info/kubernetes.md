# k8s/kubernetes notes

## add packages inside a container for troubleshooting

`apk add curl`

## troubleshooting, pods

```pod.yml
apiVersion: v1
kind: Pod
metadata:
  name: multi-container-pod
spec:
  containers:
    - name: container-1
      image: busybox
      command: ['/bin/sh', '-c', 'sleep 1d']
    - name: container-2
      image: nginx
```

official docs - https://kubernetes.io
https://github.com/devopsjourney1/learn-k8s

rancher, kubernetes as a service

## passing configs to applications

- ENV vars
- configMaps (cm)

* fetch a test config map
  `curl -O https://k8smastery.com/haproxy.cfg`
* create a configmap
  `kubectl create configmap haproxy --from-file=haproxy.cfg`
* view the contents of the configmap
  `kubectl get cm haproxy -o yaml` (cm) = configmap

## creating yaml from existing resources

`kubectl get deploy/rng -o yaml > myout.yml` dumps output of deployment that already exists into a yaml file

## you can get the kind of each resource to use in the yaml file from the api

- `kubectl api-resources | less` can also be used to figure out the api version
  needed, a empty apigroup means that the resource is in the root group
- `kubectl api-versions` shows the versions that can be used with the resource

- `kubectl explain Pod.spec` used to explain all the options for a Pod
  specification

## NodePort

default port range `30000-32768`

## kube-proxy

uses proxy and iptables to move packets around

## kubernetes networking

`ClusterIP` only availible inside the cluster
`NotePort` is design to be accessible from outside the cluster, picks by
default in 3000-32768 port range

### load balancer (external service)

cloud providers typically manage this for us

### exposing services

`NodePort` - maps a port in a high range
`LoadBalancer` external loadbalancer
`ExternalIP` maps a node's IP
`ingress` a special mechanism for handling http services

### CNI - container network interface

- can use plugins to interact withthe k8s network stack

### CNI - container network interface

- can use plugins to interact with the k8s network stack
- CNI can call IPAM plugin for address allocation
- add network interface to the pod's namespace
- configure the interface and required routes/network settings

## intalling on servers

Do `*not*` use your built-in default packages apt/yum install docker.io because
those packages are old and not the Official Docker-Built packages.

I prefer to use Docker's automated script to add their repository and install
all dependencies: `curl -sSL https://get.docker.com/ | sh` but you can also
install in a more manual method by following specific instructions that Docker
provides for your Linux distribution. `https://docs.docker.com/engine/install/`

## components

- "control-plane/master"

  - api server
  - etcd kv store
  - scheduler
  - coreDNS

- node
  - kubelet - interacts with control plane
  - kube-proxy - network stack
  - host pods, the minimun unit that can be deployed
    - pods can have multiple related containers
    - pods share an ip address, ip addresses are associated with pods not
      containers
    - containers in a pods share `localhost`
    - containers in a pods are deployed to the same node
    - we cant touch containers, we can only deploy pods

## managed cloud services like amazon, google etc

- provide a managed control-plane that becomes invisible to the user, they take
  care of managing etcd etc, the user has access to the api server to control the
  nodes and recources through the api.

# use kubectl explain to get data needed to create apis

** discover schemas for any of the k8 apis by using kubectl explain command **

`kubectl explain configmap.data`

this will return the schema needed to build automation for configmap.data

## access containers in k8

`kubectl exec -it xyz-container-name bash`
this will log in to container xyz-container-name using bash interactively

## kubescape

scan for security concerns, can also scan repos and code as well as containers
it can be integrated into the CI pipeline

## gotchas

- `configuration maps in manifest` - treat them as mutable, once defined do not
  change them

```yml
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: myconfigmapv1.1 # change the version when making changes (myconfigmapv1.2)
data:
  BG_COLOR: "#12181b"
  FONT_COLOR: "#FFFFFF"
  CUSTOM_HEADER: "DevOps Journey - lima! config map change"
```

## components

- namespaces
- pods
  - group of containers that make up an application
- replication sets
- deployments
- config maps
- kubernetes manifest
- CoreDNS - the cluter's DNS service

- servers:
  - master node
    - Api server - front end kubectl talks to it
    - Schuduler
    - controllers
    - etcd - shared k,v store
  - worker nodes
    - Runtimes docker, etc
    - Kubelet takes work from the controllers to deploy
    - Kube-proxy handles network communications

## master node components

- componetes
  - `controller manager` runs server workloads and processes
  - `etcd` database used by k8 to store info about it self. this is a k,v store
  - `api server` the front end exposed to the world
  - `scheduler` control plane process that assignes resources on the nodes,
    knows which resources have capacity

## worker node components

- `kubelet` main service, takes intructions from api server makes sure all
  containers are healthy, reports status to master, does not make decicions only
  executes them.

- `kube-proxy`

- `pod` smallest entity in a k8 cluster and has containers

### k3s, lightweight version of k8s, can run on raspberrypi etc

## commands

- load balancer

  - `kubectl expose deployment example-node --type=LoadBalancer --port=8080 -n lab`
    expose service on namespace lab
  - `minikube service hello-node -n lab` show the service configured

- kubectl

  - `kubectl cluster-info` k8 cluster info
  - `kubectl get events -n prod` get all events for namespace prod

- manage nodes

  - `kubectl get nodes` get information about nodes and their current state
  - `kubectl describe -n awx pod awx-54696666c5-fn5pb` get info about a
  - `kubectl describe node xyz` particular vm running in a pod called awx

- manage pods

  - `kubectl get pods --all-namespaces` returns all pods in all name spaces
    the `system` namespace is where k8 stores its internal components and should
    not be used.
  - `kubectl get pods -n xyz` get the pods for namespace xyz

- manage namespaces

  - `kubectl create namespace webservers`
  - `kubectl config set context webservers` change default config context

- running pods

  - `kubectl run nginx --image nginx`

- get pod status

  - `kubectl get pods -o wide` shows details about where things are running for the
    pod

- deploy new images/vms
  - `kubectl apply -f deploy_server.yml` deploys a new server to the pods created

## other notes

edit the replicas property in the deployment yaml to increase the number of vms
deployed
