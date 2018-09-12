#!/bin/bash
#TODO FIXME put credential in env?

NEXUS_IP=$1
NEXUS_PORT=$2

# Configure remote registry if defined
if [[ -z "$NEXUS_IP" || -z "$NEXUS_PORT" ]]; then
	echo "deploying local registry"
	REGISTRY_URL=localhost:5000
else
	echo "configuring docker to use remote registry $NEXUS_IP:$NEXUS_PORT"
	REGISTRY_URL=$NEXUS_IP:$NEXUS_PORT
	echo admin123 | docker login --username admin --password-stdin http://10.100.110.101:5000/v2/
fi

# TODO use a list of plugins instead
# Download, build and store the thresholding into the local registry
git clone https://gitlab.nist.gov/gitlab/WIPP/WIPP-thresholding-plugin.git ~/thresholding
cd ~/thresholding
docker build . -t wippthresh
docker tag wippthresh $REGISTRY_URL/wippthresh:0.1
docker push $REGISTRY_URL/wippthresh:0.1

# Download, build and store the convolution into the local registry
git clone https://gitlab.nist.gov/gitlab/WIPP/WIPP-convolution-plugin.git ~/convolution
cd ~/convolution
docker build . -t wippconv
docker tag wippconv $REGISTRY_URL/wippconv:0.1
docker push $REGISTRY_URL/wippconv:0.1

# Download, build and store the tiled-tiff-converter into the local registry
git clone https://gitlab.nist.gov/gitlab/WIPP/WIPP-tiledTiffConverter-plugin.git ~/tiled-tiff-converter
cd ~/tiled-tiff-converter
docker build . -t wippttconv
docker tag wippttconv $REGISTRY_URL/wippttconv:0.1
docker push $REGISTRY_URL/wippttconv:0.1