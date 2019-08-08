# WIPP deployment

Instructions to deploy WIPP 3.0 on a single-node Kubernetes cluster.

**Disclaimer:** This installation is lacking security features and is not 
considered stable yet. Alpha version, not production-ready.

## Prerequisites

### Kubernetes cluster

A Kubernetes cluster is needed for this install to work properly, following the official [instructions](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/).

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

We are using [Argo workflows](https://argoproj.github.io/argo/) to manage workflows on a Kubernetes cluster, installation instructions for version 2.2.1 can be found [here](https://github.com/argoproj/argo/blob/release-2.2/demo.md)

### Port forwarding

Several ports are forwarded for different services:
* The **Angular frontend** on port **30101**.
* The **Spring REST API backend** on port **30201**.
* An additional port may be forwarded for **Argo UI**.

### Data storage
* Data storage is managed using Kubernetes Persistent Volumes (PV) and Persistent Volume Claims (PVC). We provide templates for `hostPath` PV setup (single-node cluster only), see following instructions.
* Create a `/data/WIPP-plugins` folder on the host for data storage 
* Create the WIPP data storage Persistent Volume (PV) and Persistent Volume Claim (PVC) in your Kubernetes cluster following the templates for hostPath PV and PVC available in [the deployment folder](deployment/volumes)
    * `storage` of `capacity` is set to 100Gi by default, this value can be modified in `hostPath-wippdata-volume.yaml` and `hostPath-wippdata-pvc.yaml`
    * run `hostPath-deploy.sh` to setup the WIPP data PV and PVC

## Installation

The following command will perform the installation of the WIPP components:
```bash
git clone https://github.com/usnistgov/WIPP-deploy.git
cd WIPP-deploy/deployment
./deploy.sh
```

The WIPP 3.0 is up and running on the cluster, available on port **30101**.

**Note**: The Docker images referenced in the WIPP Deployment specs are NIST internal images for alpha-testing, not released to the public yet. For a deployment outside of NIST, the WIPP-backend and WIPP-frontend images should be built and their names (*[REPOSITORY[:TAG]]*) should be referenced in the Deployment specs.
* WIPP-backend repository: https://github.com/usnistgov/WIPP-backend
* WIPP-frontend repository: https://github.com/usnistgov/WIPP-frontend

## WIPP plugins

Manifest files to install the currently available WIPP plugins can be found in the [plugins folder](plugins)

## Contributions

This repository is using the `git-flow` publishing model. Please refer to
https://danielkummer.github.io/git-flow-cheatsheet/ for more information.

## Setup specificities

In order for the Spring backend to launch workflows, the argo binary is mounted on the container, as well as the Kubernetes credentials. This setup is a temporary insecure fix. A proper communication with the Kubernetes cluster should be setup to ensure cluster security.

## Troubleshooting

### Restart the stack

```bash
cd WIPP-deploy/deployment
./teardown.sh
./deploy.sh
```

### Argo cleanup

To completely clean previous workflows from Argo, run: `argo delete $(argo list -o name)`.
