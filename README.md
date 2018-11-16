# WIPP deployment

Infrastructure to deploy WIPP 3.0 on a single-machine Kubernetes cluster.

**Disclaimer:** This installation is lacking security features and is not 
considered stable. Never, ever, use it in production!

## Prerequisites

### Kubernetes cluster

A Kubernetes cluster is needed for this install to work properly, following the official
[instructions](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/).

Verify that the cluster is ready by typing:
```bash
watch -n1 kubectl get pods --all-namespaces
```

Something similar to the table below should be displayed. If not, wait for the 
cluster to properly start.
```
NAMESPACE     NAME                              READY     STATUS    RESTARTS   AGE
kube-system   calico-node-vwvk7                 2/2       Running   0          2m
kube-system   etcd-plugins                      1/1       Running   0          1m
kube-system   kube-apiserver-plugins            1/1       Running   0          1m
kube-system   kube-controller-manager-plugins   1/1       Running   0          1m
kube-system   kube-dns-86f4d74b45-5r8mn         3/3       Running   0          2m
kube-system   kube-proxy-78vz6                  1/1       Running   0          2m
kube-system   kube-scheduler-plugins            1/1       Running   0          1m
```

### Argo Workflow Manager

Argo Worflow Manager needs to be installed on the cluster. Follow the 
instructions located at: https://github.com/argoproj/argo/blob/master/demo.md.

### Docker registry

Every Docker image needs to be stored in a registry to be pulled by kubernetes.

To install a localhost registry, run
```bash
docker run -dt --name registry -p 5000:5000 registry:2
```

Non-HTTPS repositories need to be trusted in */etc/daemon.json* under the \
`insecure-registries` key as such:
```json
{
  "insecure-registries": ["localhost:5000"]
}
```

Change the *deployment* folder images to pull from the chosen repository.

N.B: In the case of the local registry, a deployment images named **my-image** 
should be renamed `localhost:5000/my-image` in the *deployment* folder.

### Port forwarding

Several ports need to be open for different services:
* The **Angular frontend** on port **30101**.
* The **Spring backend** on port **30201**.
* The **MongoDB** on port **30202**.
* An additional port may be forwarded for **Argo UI**.


## Installation

The following command will perform the installation of the repository:
```bash
git clone https://gitlab.nist.gov/gitlab/wipp/wipp-deploy.git
cd wipp-deploy
./scripts/install-wipp.sh
cd deployment
./deploy.sh
```

The WIPP 3.0 is up and running on the cluster, available on port **30101**.

## Contributions

This repository is using the `git-flow` publishing model. Please refer to
https://danielkummer.github.io/git-flow-cheatsheet/ for more information.

## Setup specificities

In order for the Spring backend to launch workflows, the argo binary is mounted
on the container, as well as the Kubernetes credentials. This setup is a 
temporary insecure fix. A proper communication with the Kubernetes cluster 
should be setup to ensure cluster security.

## Troubleshooting

### Restart the stack

```bash
cd wipp-deploy/deployment
./teardown.sh
./deploy.sh
```

### Argo cleanup

To completely clean previous workflows from Argo, run: `argo delete $(argo list -o name)`.
