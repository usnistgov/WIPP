# WIPP Deployment on a single-node cluster - Testing installation

WIPP relies on Kubernetes (k8s) to run. The following instructions will allow you to deploy a local testing version of WIPP on a single-node Kubernetes cluster. This configuration is insecure and not meant for production.

Please note that this installation has been tested with Kubernetes versions 1.13 to 1.18 and may not work properly with versions < 1.13.

## Installation

If you do not have Kubernetes cluster or don't know how to create one, follow the instructions below for popular operating systems to get the working local WIPP installation on your computer:

- [macOS (with Docker Desktop)](#macos-with-docker-desktop)
- [macOS (with Multipass+microk8s)](#macos-with-multipassmicrok8s)
- [Linux (Multipass+microk8s)](#linux-multipassmicrok8s)
- [Windows 10 (Multipass+microk8s)](#windows-10-multipassmicrok8s)

All of these sets of instructions assume that you have cloned or downloaded this repository, and your current working directory is set to the `deployment/wipp-complete-single-node` folder of this repository.

### Upgrading from WIPP 3.0.0-beta/beta2 WIPP-3.0.0

If you already have a running instance of WIPP 3.0.0-beta and want to upgrade to WIPP 3.0.1, please follow the upgrade instructions according to your installation setup:

- [macOS (with Docker Desktop)](#macos-with-docker-desktop) - follow steps 4 to 10
- [macOS (with Multipass+microk8s)](#macos-with-multipassmicrok8s) - follow steps 4 to 10
- [Linux (Multipass+microk8s)](#linux-multipassmicrok8s) - follow steps 4 to 10
- [Windows 10 (Multipass+microk8s)](#windows-10-multipassmicrok8s) - follow steps 5 to 12

These instructions assume that you have pulled or downloaded the latest version of this repository, and your current working directory is set to the `deployment/wipp-complete-single-node` folder of this repository.

### Upgrading from WIPP 3.0.0

If you already have a running instance of WIPP 3.0.0 and want to upgrade to WIPP 3.0.1 (recommended), please follow the upgrade instructions according to your installation setup:

- [macOS (with Docker Desktop)](#macos-with-docker-desktop) - follow steps 4 to 8
- [macOS (with Multipass+microk8s)](#macos-with-multipassmicrok8s) - follow steps 4 to 8
- [Linux (Multipass+microk8s)](#linux-multipassmicrok8s) - follow steps 4 to 8
- [Windows 10 (Multipass+microk8s)](#windows-10-multipassmicrok8s) - follow steps 5 to 10

These instructions assume that you have pulled or downloaded the latest version of this repository, and your current working directory is set to the `deployment/wipp-complete-single-node` folder of this repository.

### Volume size considerations

Kubernetes require to specify the volume size before deploying apps. `wipp-single-node.yaml` contains some reasonable defaults for testing WIPP on a single computer/laptop, which you might want to change to better suit your case. Below is the list of volumes with default size and reference to config, so you can change them before deploying.

| Volume name                                         | Purpose                                    | Default size |
|-----------------------------------------------------|--------------------------------------------|--------------|
| [`mongo-pv-claim`](wipp-single-node.yaml#L157)     | MongoDB database for WIPP                  | 1Gi          |
| [`postgres-pv-claim`](wipp-single-node.yaml#L214)     | Postgres database for WIPP-Keycloak     | 1Gi          |
| [`wipp-pv-claim`](wipp-single-node.yaml#L554)      | WIPP storage for images and data           | 20Gi         |
| [`notebooks-pv-claim`](wipp-single-node.yaml#L989) | Shared storage for all Notebook users      | 5Gi          |
| [`claim-{username}`](wipp-single-node.yaml#L532)   | Individual storage for each Notebook users | 1Gi          |

### macOS (with Docker Desktop)

1. Download and install Docker Desktop. Follow instructions here: https://docs.docker.com/docker-for-mac/install/ You will need to create free Docker ID to get access to .dmg download
2. Once installed, click on the Docker logo and choose **Preferences** → **Advanced**. Depending on your Mac configuration, choose the appropriate amount of CPU, RAM and disk available for WIPP (and all Docker containers).
3. After that go to **Preferences** → **Kubernetes** → **Enable Kubernetes**. Wait for the *Kubernetes is running* status and the green indicator in the bottom right corner of the window.
4. Find the ip address of your Mac on the local network: click **Network** <img src="https://icon-library.net/images/mac-wifi-icon/mac-wifi-icon-23.jpg" width="10"> → **Open Network Preferences …** and copy the IP address from this line: *Wi-Fi is connected to <WIFI_NAME> and has the IP address x.x.x.x*.
5. Replace all occurences of `localhost` in `wipp-single-node.yaml` and `wipp-realm.json` to the IP address from previous step: `x.x.x.x`. 
Example with `gsed` (remember to replace `x.x.x.x` by the actual IP value):

```sh
gsed -i 's|localhost|x.x.x.x|g' wipp-single-node.yaml
gsed -i 's|localhost|x.x.x.x|g' wipp-realm.json
```

6. Deploy WIPP. Open the terminal and run:

```
kubectl create secret generic wipp-realm-secret --from-file=wipp-realm.json
kubectl apply -f wipp-single-node.yaml
```

7. Check that the WIPP pods are running (it may take a few minutes for the Docker images to be downloaded and containers to be started):

```
kubectl get pods
```

Output should be similar to this one for the pods starting with `wipp-`:

```
NAME                             READY   STATUS      RESTARTS   AGE
wipp-backend-xxxxxxxxxx-xxxxx    1/1     Running     0          5m
wipp-frontend-xxxxxxxxxx-xxxxx   1/1     Running     0          5m
wipp-keycloak-xxxxxxxxxx-xxxxx   1/1     Running     0          5m
wipp-tensorboard-xxxxxxx-xxxxx   1/1     Running     0          5m
```

8. In browser, access the apps at the following addresses:
   * WIPP: x.x.x.x:32001 
   * Argo: x.x.x.x:32002
   * Notebooks: x.x.x.x:32003
   * Plots: x.x.x.x:32004
   * Tensorboard: x.x.x.x:32005
   * Keycloak: x.x.x.x:32006
   
9. Follow the [Post-installation instructions](wipp-post-installation-notes.md) to set up a WIPP admin user and start user WIPP.

10. (Optional) If you are upgrading from WIPP beta/beta2, a database migration is necessary for existing data to be accessible:

```
kubectl apply -f wipp-database-migration-3.0.0.yaml
```

### macOS (with Multipass+microk8s)

1. Download and install Multipass for Mac: https://multipass.run/#install Multipass creates on-demand Linux VMs and provides an easy way to run Kubernetes using microk8s. 
2. Once installed, open the terminal and create VM:

```
multipass launch --name wipp --cpus 4 --mem 8G --disk 100G ubuntu
```

Depending on your Mac configuration, choose the appropriate amount of CPU, RAM and disk available for WIPP.
3. Install and start microk8s:
```
multipass exec wipp -- sudo apt update
multipass exec wipp -- sudo apt install docker.io
multipass exec wipp -- sudo snap install microk8s --classic
multipass exec wipp -- sudo iptables -P FORWARD ACCEPT
multipass exec wipp -- sudo usermod -a -G microk8s ubuntu
multipass exec wipp -- /snap/bin/microk8s.start
multipass exec wipp -- /snap/bin/microk8s.enable rbac
multipass exec wipp -- /snap/bin/microk8s.enable dns
multipass exec wipp -- /snap/bin/microk8s.status --wait-for-ready
multipass exec wipp -- /snap/bin/microk8s.enable storage
```
4. Find the IP of Multipass VM:
```
multipass info wipp | grep IP
> IPv4:           x.x.x.x
```
5. Replace all occurences of `localhost` in `wipp-single-node.yaml` and `wipp-realm.json` to the IP address from previous step: `x.x.x.x`.
Example with `gsed` (remember to replace `x.x.x.x` by the actual IP value):

```sh
gsed -i 's|localhost|x.x.x.x|g' wipp-single-node.yaml
gsed -i 's|localhost|x.x.x.x|g' wipp-realm.json
```

6. Copy the Kubernetes config and deploy WIPP (install `kubectl` if not present: https://kubernetes.io/docs/tasks/tools/install-kubectl/)
```
multipass exec wipp -- /snap/bin/microk8s.config > kubeconfig
kubectl --kubeconfig=kubeconfig create secret generic wipp-realm-secret --from-file=wipp-realm.json
kubectl --kubeconfig=kubeconfig apply -f wipp-single-node.yaml
```

7. Check that the WIPP pods are running (it may take a few minutes for the Docker images to be downloaded and containers to be started):

```
kubectl --kubeconfig=kubeconfig get pods
```

Output should be similar to this one for the pods starting with `wipp-`:

```
NAME                             READY   STATUS      RESTARTS   AGE
wipp-backend-xxxxxxxxxx-xxxxx    1/1     Running     0          5m
wipp-frontend-xxxxxxxxxx-xxxxx   1/1     Running     0          5m
wipp-keycloak-xxxxxxxxxx-xxxxx   1/1     Running     0          5m
wipp-tensorboard-xxxxxxx-xxxxx   1/1     Running     0          5m
```

8. In browser, access the apps at the following addresses:
   * WIPP: x.x.x.x:32001 
   * Argo: x.x.x.x:32002
   * Notebooks: x.x.x.x:32003
   * Plots: x.x.x.x:32004
   * Tensorboard: x.x.x.x:32005
   * Keycloak: x.x.x.x:32006

9. Follow the [Post-installation instructions](wipp-post-installation-notes.md) to set up a WIPP admin user and start user WIPP.

10. (Optional) If you are upgrading from WIPP beta/beta2, a database migration is necessary for existing data to be accessible:

```
kubectl --kubeconfig=kubeconfig apply -f wipp-database-migration-3.0.0.yaml
```

### Linux (Multipass+microk8s)

1. Install Multipass from Snap Store:
```
sudo snap install multipass --classic --beta
```
2. Once installed, open the terminal and create VM:
```
multipass launch --name wipp --cpus 4 --mem 8G --disk 100G ubuntu
```
3. Install and start microk8s:
```
multipass exec wipp -- sudo apt update
multipass exec wipp -- sudo apt install docker.io
multipass exec wipp -- sudo snap install microk8s --classic
multipass exec wipp -- sudo iptables -P FORWARD ACCEPT
multipass exec wipp -- sudo usermod -a -G microk8s ubuntu
multipass exec wipp -- /snap/bin/microk8s.start
multipass exec wipp -- /snap/bin/microk8s.enable rbac
multipass exec wipp -- /snap/bin/microk8s.enable dns
multipass exec wipp -- /snap/bin/microk8s.status --wait-for-ready
multipass exec wipp -- /snap/bin/microk8s.enable storage
```
4. Find the IP of Multipass VM:
```
multipass info wipp | grep IP
> IPv4:           x.x.x.x
```
5. Replace all occurences of `localhost` in `wipp-single-node.yaml` and `wipp-realm.json` to the IP address from previous step: `x.x.x.x`.
Example with `sed` (remember to replace `x.x.x.x` by the actual IP value):

```sh
sed -i 's|localhost|x.x.x.x|g' wipp-single-node.yaml
sed -i 's|localhost|x.x.x.x|g' wipp-realm.json
```

6. Copy the Kubernetes config and deploy WIPP (install `kubectl` if not present: https://kubernetes.io/docs/tasks/tools/install-kubectl/):
```
multipass exec wipp -- /snap/bin/microk8s.config > kubeconfig
kubectl --kubeconfig=kubeconfig create secret generic wipp-realm-secret --from-file=wipp-realm.json
kubectl --kubeconfig=kubeconfig apply -f wipp-single-node.yaml
```

7. Check that the WIPP pods are running (it may take a few minutes for the Docker images to be downloaded and containers to be started):

```
kubectl --kubeconfig=kubeconfig get pods
```

Output should be similar to this one for the pods starting with `wipp-`:

```
NAME                             READY   STATUS      RESTARTS   AGE
wipp-backend-xxxxxxxxxx-xxxxx    1/1     Running     0          5m
wipp-frontend-xxxxxxxxxx-xxxxx   1/1     Running     0          5m
wipp-keycloak-xxxxxxxxxx-xxxxx   1/1     Running     0          5m
wipp-tensorboard-xxxxxxx-xxxxx   1/1     Running     0          5m
```

8. In browser, access the apps at the following addresses:
   * WIPP: x.x.x.x:32001 
   * Argo: x.x.x.x:32002
   * Notebooks: x.x.x.x:32003
   * Plots: x.x.x.x:32004
   * Tensorboard: x.x.x.x:32005
   * Keycloak: x.x.x.x:32006

9. Follow the [Post-installation instructions](wipp-post-installation-notes.md) to set up a WIPP admin user and start user WIPP.

10. (Optional) If you are upgrading from WIPP beta/beta2, a database migration is necessary for existing data to be accessible:

```
kubectl --kubeconfig=kubeconfig apply -f wipp-database-migration-3.0.0.yaml
```

### Windows 10 (Multipass+microk8s)
Make sure you have Windows 10 Pro, Enterprise or Education to use the standard Multipass installation with Hyper-V; Windows 10 Home is not supported and will require an installation of VirtualBox.

1. Enable Hyper-V on Windows: https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v  
If you are unable to enable Hyper-V, or prefer to use VirtualBox, please refer to this [online documentation for installing Multipass on Windows](https://discourse.ubuntu.com/t/installing-multipass-for-windows/9547) and follow the instructions for VirtualBox.
2. Download and install Multipass for Windows: https://multipass.run/#install Multipass creates on-demand Linux VMs and provides an easy way to run Kubernetes using microk8s. 
3. Create Multipass VM:
```
multipass launch --name wipp --cpus 4 --mem 8G --disk 100G ubuntu
```
Depending on your PC configuration, choose the appropriate amount of CPU, RAM and disk available for WIPP.

4. Install and start microk8s:
```
multipass exec wipp -- sudo apt update
multipass exec wipp -- sudo apt install docker.io
multipass exec wipp -- sudo snap install microk8s --classic
multipass exec wipp -- sudo iptables -P FORWARD ACCEPT
multipass exec wipp -- sudo usermod -a -G microk8s ubuntu
multipass exec wipp -- /snap/bin/microk8s.start
multipass exec wipp -- /snap/bin/microk8s.enable rbac
multipass exec wipp -- /snap/bin/microk8s.enable dns
multipass exec wipp -- /snap/bin/microk8s.status --wait-for-ready
multipass exec wipp -- /snap/bin/microk8s.enable storage
```
5. Print the Kubernetes config:
```
multipass exec wipp -- /snap/bin/microk8s.config
```
Copy the output of the command to `kubeconfig` file in the current directory.

6. Find the IP of Multipass VM:
```
multipass info wipp
```
Copy the IP address `x.x.x.x`.

7. Replace all occurences of `localhost` in `wipp-single-node.yaml` and `wipp-realm.json` to the IP address from previous step: `x.x.x.x`.

8. Deploy WIPP (install `kubectl` if not present: https://kubernetes.io/docs/tasks/tools/install-kubectl/):
```
kubectl --kubeconfig=kubeconfig create secret generic wipp-realm-secret --from-file=wipp-realm.json
kubectl.exe --kubeconfig=kubeconfig apply -f wipp-single-node.yaml
```

9. Check that the WIPP pods are running (it may take a few minutes for the Docker images to be downloaded and containers to be started):

```
kubectl.exe --kubeconfig=kubeconfig get pods
```

Output should be similar to this one for the pods starting with `wipp-`:

```
NAME                             READY   STATUS      RESTARTS   AGE
wipp-backend-xxxxxxxxxx-xxxxx    1/1     Running     0          5m
wipp-frontend-xxxxxxxxxx-xxxxx   1/1     Running     0          5m
wipp-keycloak-xxxxxxxxxx-xxxxx   1/1     Running     0          5m
wipp-tensorboard-xxxxxxx-xxxxx   1/1     Running     0          5m
```

10. In browser, access the apps at the following addresses:
   * WIPP: x.x.x.x:32001 
   * Argo: x.x.x.x:32002
   * Notebooks: x.x.x.x:32003
   * Plots: x.x.x.x:32004
   * Tensorboard: x.x.x.x:32005
   * Keycloak: x.x.x.x:32006

11. Follow the [Post-installation instructions](wipp-post-installation-notes.md) to set up a WIPP admin user and start user WIPP.

12. (Optional) If you are upgrading from WIPP beta/beta2, a database migration is necessary for existing data to be accessible:

```
kubectl --kubeconfig=kubeconfig apply -f wipp-database-migration-3.0.0.yaml
```

## Teardown

There are couple of important considerations to keep in mind. If you perform the full teardown, all the data generated or uploaded in any of the apps (WIPP, Notebooks, Plots) **will be lost**. It is possible to do a partial teardown when only the apps are deleted but all the data persist, so you can reinstall WIPP again in the future and continue to use it in the state you left it in. If you would like to delete WIPP from your computer, follow the instructions below:

- [when using Docker for Mac](#Teardown-in-Docker-Desktop)
- [when using Multipass+microk8s](#Teardown-in-Multipass)

#### Teardown in Docker Desktop

1. Delete all resources created by WIPP (deployments, services, storage, etc.):
```
kubectl delete -f wipp-single-node.yaml
```
2. (OPTIONAL) Turn of Kubernetes cluster in Docker settings. In  Docker menu go to **Preferences** → **Kubernetes** and uncheck **Enable Kubernetes**.
3. (OPTIONAL) For complete teardown, you can delete Docker Desktop

#### Teardown in Multipass

1. Delete all resources created by WIPP (deployments, services, storage, etc.):
```
kubectl --kubeconfig=kubeconfig delete -f wipp-microk8s.yaml
```
2. (OPTIONAL) Delete Multipass VM:
```
multipass stop wipp
multipass delete wipp
multipass purge
```
3. (OPTIONAL) Delete Multipass from your computer
