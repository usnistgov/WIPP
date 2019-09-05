#!/bin/sh
if [ $# -ne 4 ]
then
  echo "Illegal number of parameters. Exiting..."
  echo "Command: ./entrypoint.sh \${backend_host} \${backend_port} \${tensorboard_host} \${tensorboard_port}"
fi

BACKEND_HOST=$1
BACKEND_PORT=$2
TENSORBOARD_HOST=$3
TENSORBOARD_PORT=$4

sed -i \
  -e 's/@backend_host@/'"${BACKEND_HOST}"'/' \
  -e 's/@backend_port@/'"${BACKEND_PORT}"'/' \
  -e 's/@tensorboard_host@/'"${TENSORBOARD_HOST}"'/' \
  -e 's/@tensorboard_port@/'"${TENSORBOARD_PORT}"'/' \
  /etc/nginx/conf.d/default.conf

nginx -g 'daemon off;'
