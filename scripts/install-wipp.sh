#!/bin/bash
DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
REGISTRY_HOST=$1
REGISTRY_PORT=$2
REGISTRY_USER=$3
REGISTRY_PASS=$4

# Configure remote registry if defined
if [[ -z "${REGISTRY_HOST}" || -z "${REGISTRY_PORT}" ]]; then
	echo "Deploying local registry..."
	REGISTRY_URL=localhost:5000
else
	echo "Configuring docker to use remote registry at ${REGISTRY_HOST}:${REGISTRY_PORT}..."
	REGISTRY_URL=${REGISTRY_HOST}:${REGISTRY_PORT}

	echo ${REGISTRY_PASS} | docker login --username ${REGISTRY_USER} --password-stdin http://${REGISTRY_URL}
fi

echo "Registry ready. Building WIPP images..."

# Build images for WIPP 3.0
cd ${DIRNAME}/../docker
docker-compose build

docker tag frontend ${REGISTRY_URL}/wipp/frontend
docker push ${REGISTRY_URL}/wipp/frontend
docker tag backend ${REGISTRY_URL}/wipp/backend
docker push ${REGISTRY_URL}/wipp/backend

echo "WIPP images built and pushed. Installing plugins..."

bash -c "${DIRNAME}/install-plugins.sh ${REGISTRY_URL}"

echo "Plugin installed."
