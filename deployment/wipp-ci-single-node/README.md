# WIPP deployment

Instructions to deploy WIPP 3.0 on a single-node Kubernetes cluster.

**Disclaimer:** This installation is lacking security features and is not 
considered stable yet. Beta version, not production-ready.

## Prerequisites

### Kubernetes cluster

* Installed Kubernetes 1.9 or later
* Installed [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* Have a [kubeconfig](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/) file (default location is `~/.kube/config`).

A Kubernetes cluster should be set up before starting the WIPP installation. Official instructions for setting up a Kubernetes cluster using `kubeadm` can be found [here](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/).

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

* Installed Argo Workflows 2.3.0

We are using [Argo workflows](https://argoproj.github.io/argo/) to manage workflows on a Kubernetes cluster, installation instructions for version 2.3.0 can be found [here](https://github.com/argoproj/argo/blob/master/demo.md)

### Port forwarding

Several ports are forwarded for different services:
* The **Angular frontend** on port **30101**
* The **Spring REST API backend** on port **30201**
* The **Argo UI** on port **30501**
* The **Tensorboard** on port **30601**

### Data storage
* Data storage is managed using Kubernetes Persistent Volumes (PV) and Persistent Volume Claims (PVC). We provide templates for `hostPath` PV setup (single-node cluster only), see following instructions.
* Create a `/data/WIPP-plugins` folder on the host for data storage 
* Create the WIPP data storage Persistent Volume (PV) and Persistent Volume Claim (PVC) in your Kubernetes cluster following the templates for hostPath PV and PVC available in [the deployment folder](deployment/volumes)
    * `storage` of `capacity` is set to 100Gi by default, this value can be modified in `hostPath-wippdata-volume.yaml` and `hostPath-wippdata-pvc.yaml`
    * run `hostPath-deploy.sh` to setup the WIPP data PV and PVC

## Installation

The following command will perform the installation of the WIPP components:
```bash
git clone https://github.com/usnistgov/WIPP.git
cd WIPP/deployment/wipp-ci-single-node
./deploy.sh
```

The WIPP 3.0 is up and running on the cluster, and the WIPP UI is available on port **30101**.


## Troubleshooting

### Restart the stack

```bash
cd WIPP/deployment/wipp-ci-single-node
./teardown.sh
./deploy.sh
```

### Argo cleanup

To completely clean previous workflows from Argo, run: `argo delete $(argo list -o name)`.
