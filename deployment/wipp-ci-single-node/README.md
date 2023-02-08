# WIPP deployment

Instructions to deploy WIPP 3.x on a bare-metal Kubernetes cluster.

**Disclaimer:** Some of these instructions have not been tested on multi-node clusters, configuration of PVCs might have to be adjusted. These are starting point instructions, to be adjusted depending on expected load and security requirements.

## Prerequisites

### Kubernetes cluster

* Installed Kubernetes 1.16 or later
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

* Installed Argo Workflows 2.3.0 or later

We are using [Argo workflows](https://argoproj.github.io/argo/) to manage workflows on a Kubernetes cluster, installation instructions for version 2.3.0 can be found [here](https://github.com/argoproj/argo/blob/master/demo.md)
Ingress for this version is `argo-ui-ingress.yaml`, more recent versions use the `argo-server-ingress.yaml`.

### Ingress

These instructions assume HTTPS deployment with Kubernetes Nginx Ingress:
- Ingress controller installed,
- DNS aliases/hostnames exist for each service (for example, if the target hostname is `example.com`, then the following DNS aliases should also exist: `wipp.example.com`, `wipp-api.nist.gov`, `argo.example.com`, `keycloak.example.com`, `tensorboard.example.com`). 
- Certificates,
- TLS secrets have been created for the namespace where WIPP is deployed and the namespace where Argo is installed, for example (replace WIPP_TLS_SECRET by actual name of the secret, for example `wipp-tls`):
```
kubectl create secret tls WIPP_TLS_SECRET \
  --cert=/path/to/cert/cert.cer \
  --key=/path/to/cert/cert.key
kubectl -n argo create secret tls WIPP_TLS_SECRET \
  --cert=/path/to/cert/cert.cer \
  --key=/path/to/cert/cert.key
```

In each ingress manifest, replace the SERVICE_HOSTNAME_VALUE by the actual hostname and the WIPP_TLS_SECRET by the actual secret name.

# Secrets
Copy keycloak-secret-sample to keycloak-secret and modify the password values (replace `<password>`).

Create the keycloak secret:
```
kubectl create secret generic keycloak --from-env-file=keycloak-secret
```
Create realm secret if it does not exist already:
```
kubectl create secret generic wipp-realm-secret --from-file=wipp-realm.json
```

Copy postegres-secret-sample to postgres-secret and modify the password values (replace `<password>`).

Create Kubernetes secret for database name, user and password:
```
kubectl create secret generic postgres --from-env-file=postgres-secret
```

### Configuration
- backend-deployment: replace `WIPP_BACKEND_IMAGE` by Docker image name to deploy, replace env values, for example (sample minimal configuration):
```
env:
            - name: KEYCLOAK_AUTH_URL
              value: "https://keycloak.example.com/auth"
            - name: KEYCLOAK_SSL_REQUIRED
              value: "none"
            - name: KEYCLOAK_DISABLE_TRUST_MANAGER
              value: "true"
            - name: ELASTIC_APM_SERVER_URLS
              value: ""
            - name: ELASTIC_APM_SERVICE_NAME
              value: wipp-backend
            - name: ELASTIC_APM_APPLICATION_PACKAGES
              value: gov.nist.itl.ssd.wipp.backend
```
- frontend-deployment: replace `WIPP_FRONTEND_IMAGE` by Docker image name to deploy, replace env values, for example (sample minimal configuration):
```
env:
        - name: ARGOUIBASE_URL
          value: https://argo.example.com/workflows/default
        - name: KEYCLOAK_URL
          value: https://keycloak.example.com/auth
        - name: TENSORBOARD_URL
          value: https://tensorboard.example.com
```


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

The WIPP 3.x is up and running on the cluster, and the WIPP UI is available at `https://WIPP_HOSTNAME_VALUE`.


