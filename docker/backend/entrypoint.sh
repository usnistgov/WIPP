#!/bin/sh
if [ $# -ne 2 ]
then
  echo "Illegal number of parameters. Exiting..."
  echo "Command: ./entrypoint.sh \${mongo_host} \${mongo_port}"
fi

MONGO_HOST=$1
MONGO_PORT=$2

sed -i \
  -e 's/@mongo_host@/'"${MONGO_HOST}"'/' \
  -e 's/@mongo_port@/'"${MONGO_PORT}"'/' \
  /opt/wipp/config/application.properties

exec /usr/bin/java -jar /opt/wipp/wipp-backend.war
