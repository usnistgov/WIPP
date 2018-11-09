#!/bin/bash
DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
PLUGINS_LIST="${DIRNAME}/plugins.txt"
REGISTRY_URL=$1

# Download, build and store the plugin in the repository
for plugin_name in $(cat ${PLUGINS_LIST})
do
  echo "Downloading ${plugin_name}..."

  git clone https://gitlab.nist.gov/gitlab/WIPP/${plugin_name}.git /tmp/${plugin_name}
  cd /tmp/${plugin_name}
  docker build . -t ${plugin_name}
  docker tag ${plugin_name} ${REGISTRY_URL}/${plugin_name}:0.1
  docker push ${REGISTRY_URL}/${plugin_name}:0.1

  echo "Plugin ${plugin_name} build and pushed."
done
