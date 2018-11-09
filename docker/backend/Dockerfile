FROM openjdk:8-jdk-alpine

EXPOSE 8080

ARG BACKEND_NAME="wipp-backend-application"
ARG BACKEND_VERSION="3.0.0-SNAPSHOT"

RUN mkdir -p \
  /opt/nexus-download \
  /opt/wipp/config \
  /data/plugins/workflows \
  /data/plugins/jobs_tmp \
  /data/plugins/coll \
  /data/plugins/coll_tmp

COPY nexus-download /opt/nexus-download

RUN sh /opt/nexus-download/nexus-download.sh \
  gov.nist.itl.ssd.wipp \
  ${BACKEND_NAME} \
  ${BACKEND_VERSION} \
  war exec \
  && cp $(find / -name "${BACKEND_NAME}-${BACKEND_VERSION}*") /opt/wipp/wipp-backend.war

COPY application.properties /opt/wipp/config
COPY entrypoint.sh /usr/local/bin

WORKDIR "/opt/wipp"
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
