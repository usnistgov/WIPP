FROM nginx:1.14.0

ARG NEXUS_URL="http://vm-itl-ssd-201.nist.gov:8081/nexus/repository"
ARG WIPP_FRONTEND_URL="wipp-frontend/wipp-frontend-0.1.0/latest/WIPP-frontend.tar.gz"

RUN apt-get update \
  && apt-get install -y \
    wget \
    tar \
    vim

WORKDIR /var/www/

RUN wget ${NEXUS_URL}/${WIPP_FRONTEND_URL} \
  && tar -xvzf WIPP-frontend.tar.gz \
  && mv WIPP-frontend frontend

COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
