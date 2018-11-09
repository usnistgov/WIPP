#!/bin/sh
if [ $# -ne 2 ]
then
  echo "Illegal number of parameters. Exiting..."
  echo "Command: ./entrypoint.sh \${backend_host} \${backend_port}"
fi

BACKEND_HOST=$1
BACKEND_PORT=$2

sed -i \
  -e 's/@backend_host@/'"${BACKEND_HOST}"'/' \
  -e 's/@backend_port@/'"${BACKEND_PORT}"'/' \
  /etc/nginx/conf.d/default.conf

nginx -g 'daemon off;'
