#!/bin/bash
SCRIPT_PATH="$(dirname $0)"
ARGS_ERROR="Illegal number of arguments. Please use: group artifact [version] [extension] [classifier]"

if [ $# -lt 2 ]
then
    echo ${ARGS_ERROR}
    exit 1
fi

group="$1"
artifact="$2"

if [ $# -eq 2 ]
then
    query="$group:$artifact"
elif [ $# -eq 3 ]
then
    query="$group:$artifact:$3"
elif [ $# -eq 4 ]
then
    query="$group:$artifact:$4:$3"
elif [ $# -eq 5 ]
then
    query="$group:$artifact:$4:$5:$3"
else
    echo ${ARGS_ERROR}
    exit 2
fi

nexus_creds="admin:admin123"
#nexus_repo="https://vm-itl-ssd-201.nist.gov/nexus/repository/maven-local"
nexus_repo="http://vm-itl-ssd-201.nist.gov:8081/nexus/repository/maven-local"

java -jar ${SCRIPT_PATH}/artifactResolver.jar -u ${nexus_creds} -r ${nexus_repo} -l "/tmp" ${query}
