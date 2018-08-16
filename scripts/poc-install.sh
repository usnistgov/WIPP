#!/bin/bash
NEXUS_IP=$1
NEXUS_PORT=$2

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
PARENT_DIR=$(dirname "$SCRIPT_PATH")

# Configure remote registry if defined
if [[ -z "$NEXUS_IP" || -z "$NEXUS_PORT" ]]; then
	echo "deploying local registry"
	docker run -d --name registry -p 5000:5000 --restart always registry:2
else
	echo "configuring docker to use remote registry $NEXUS_IP:$NEXUS_PORT"
	sudo python dockerconf.py $NEXUS_IP $NEXUS_PORT
	sudo systemctl restart docker
fi

# Install java 8, node, npm and maven
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
curl -L https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs openjdk-8-jdk maven
sudo npm install npm@latest -g

# Start docker containers for MongoDB and Docker registry
docker run -dt --name mongo -p 27017:27017 --restart always mongo

# Setup the Angular GUI
git clone https://gitlab.nist.gov/gitlab/fss/plugins-ui-ngx.git ~/gui
cd ~/gui
npm install

for f in `find ./src -name "*.ts"`
do
    sed -i \
        -e "s;localhost:8080;localhost:51502;g" \
        ${f}
done
nohup npm start &

# Setup Spring backend
git clone https://gitlab.nist.gov/gitlab/fss/plugins-backend.git ~/backend
cd ~/backend
cp $PARENT_DIR/files/default.yaml ./data/workflows/default.yaml
nohup mvn spring-boot:run &
cd -

# Create data folder
cp -r $PARENT_DIR/data ~/data

