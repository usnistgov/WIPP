#!/bin/bash
#
#
if [ $# -lt 1 ]
then
	echo "Illegal number of arguments. Please use: ./poc-install.sh \$api_addr [\$nexus_ip \$nexus_port]"
	exit
fi

# Script parameters
API_ADDR="$1"
NEXUS_IP=$2
NEXUS_PORT=$3

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
PARENT_DIR=$(dirname "$SCRIPT_PATH")

# Configure remote registry if defined
if [[ -z "$NEXUS_IP" || -z "$NEXUS_PORT" ]]; then
	echo "Deploying local registry..."
	docker run -d --name registry -p 5000:5000 --restart always registry:2
else
	echo "Configuring docker to use registry at $NEXUS_IP:$NEXUS_PORT..."
	sudo python ${SCRIPT_PATH}/dockerconf.py $NEXUS_IP $NEXUS_PORT
	sudo systemctl restart docker
fi
echo "Docker registry configured..."

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

# TODO Replace with a better method
# Setup the address of the Spring API within the frontend
for f in `find ./src -name "*.ts"`
do
    sed -i \
        -e "s;localhost:8080;${API_ADDR};g" \
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

