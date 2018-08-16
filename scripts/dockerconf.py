import sys, json; 
from pprint import pprint

if len(sys.argv) < 3:
	raise ValueError('This scripts needs NEXUS_IP and NEXUS_PORT arguments')

NEXUS_IP = sys.argv[1]
NEXUS_PORT = sys.argv[2]

with open('/etc/docker/daemon.json', "r") as f:
    data = json.load(f)

data["insecure-registries"]=['%s:%s'%(NEXUS_IP,NEXUS_PORT)]
with open('/etc/docker/daemon.json', "w") as jsonFile:
    json.dump(data, jsonFile, indent=2)
