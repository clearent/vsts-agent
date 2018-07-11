FROM microsoft/vsts-agent:ubuntu-16.04-tfs-2018-u2-docker-17.06.0-ce-standard

#Install kerberos for integrated sql authentication
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update && \
    apt-get -qq install krb5-user

VOLUME ["/keys"]
