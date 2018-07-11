FROM microsoft/vsts-agent:ubuntu-16.04-tfs-2018-u2-docker-17.06.0-ce-standard

#Install kerberos for integrated sql authentication
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update && \
    apt-get -qq install krb5-user

VOLUME ["/keys"]

ENV RANCHER_COMPOSE_VERSION 0.12.5

COPY rancher-deploy.sh /usr/local/bin/rancher-deploy.sh

RUN apt-get install -y gettext-base && \
    curl https://releases.rancher.com/compose/v0.12.5/rancher-compose-linux-amd64-v0.12.5.tar.gz -o rancher-compose.tgz && \
    tar zxvf rancher-compose.tgz && \
    ln -s /vsts/rancher-compose-v0.12.5/rancher-compose /usr/local/bin/rancher-compose