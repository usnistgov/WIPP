# Single-machine Kubernetes Cluster. 

Infrastructure for a single-machine Kubernetes cluster.
However, this install can be the starting point for a creating a cluster of kubernetes nodes.

**Disclaimer:** This installation is lacking security features and is not 
considered stable. Never, ever, use it in production!

## Prerequisites

Install the **Vagrant** software following the steps describe at 
https://www.vagrantup.com/docs/installation/. Install the `vagrant-disksize`
plugin with the following command:

```bash
vagrant plugin install vagrant-disksize
```

[Requirements](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/)

One or more machines running a deb/rpm-compatible OS, for example Ubuntu or CentOS
2 GB or more of RAM per machine. Any less leaves little room for your apps.
2 CPUs or more on the master
Full network connectivity among all machines in the cluster. A public or private network is fine.```

The resources needed for the VM are listed below:
* 2 CPUs
* 4 GB of RAM
* 30 GB of HDD

These requirements are minimal and mainly driven by the Kubernetes 
requirements. The machine broadcasts on 4 ports (51501-51504). If you wish to 
access the application externally make sure to allow traffic on these ports.


## Machine startup

To setup the machine, run `vagrant up`. The *${INSTALL_DIR}/scripts/bootstrap.sh* script is run as
the provisioning script.

Login to the machine by typing `vagrant ssh plugins` or `${INSTALL_DIR}/login.sh`.


## Cluster status check

Verify that the single-node cluster is ready by typing:
```bash
watch -n1 kubectl get pods --all-namespaces
```

You should see something similar to the table below. If not, wait for the 
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

## Software installation

Install the plugins POC by running `${INSTALL_DIR}/scripts/poc-install.sh`.

Four services are running on the VM:
* The **Angular frontend** on port **51501**
* The **Spring backend** on port **51502**
* The **MongoDB** on port **51503**
* The **Argo UI** on port **51504**

## Plugins installation

Three plugins are provided with this example:
* The thresholding plugin
* The convolution plugin
* The tiled tiff conversion plugin

To add the plugin images to the local registry, run 
`${INSTALL_DIR}/scripts/plugin-install.sh`.

Go to http://localhost:51501/plugins and enter any of the JSON located in the 
*plugins* folder to register the plugins.

## Usage

During the POC installation, some data have been copied to */home/vagrant/data*.
This folder contains 2 subfolders:
* *original* containing 5 regular TIFF images.
* *tiled* containing the tiled TIFF versions of the *original* images.

Go to http://localhost:51501/workflows to create a new worflow using these 
images. Keep in mind that:
* The thresholding plugin can take TIFF or tiled TIFF but only produces TIFF.
* The convolution plugin needs tiled TIFF as input.
* The conversion plugin accepts TIFF as input and outputs tiled TIFF.
* The worflow system can map output from previous steps by starting typing `{{` 
in the image search bar.

## Contributions

This repository is using the `git-flow` publishing model. Please refer to
https://danielkummer.github.io/git-flow-cheatsheet/ for more information.

## Troubleshooting

### Machine restart

If the machine is rebooted, the UI and backend will not be restarted. To 
restart them, run `${INSTALL_DIR}/scripts/restart.sh`


### Reset MongoDB

If MongoDB need to be reset, use the following commands:
```bash
docker stop mongo && docker rm mongo
docker run -dt --name mongo -p 27017:27017 --restart always mongo
```


### Argo cleanup

To completely clean previous workflows from Argo, run: `argo delete $(argo list -o name)`.
