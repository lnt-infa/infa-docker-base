FROM centos:7.4.1708
MAINTAINER LNT

USER root

# install dev tools
RUN yum clean all; \
    rpm --rebuilddb; \
    yum install -y curl which tar sudo openssh-server openssh-clients rsync
# update libselinux. see https://github.com/sequenceiq/hadoop-docker/issues/14
RUN yum update -y libselinux

# passwordless ssh
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key \
    ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config \
    chown root:root /root/.ssh/config

RUN curl  -LO https://raw.githubusercontent.com/lnt-infa/docker-common-scripts/master/consulFunctions.sh && cp consulFunctions.sh /etc/consulFunctions.sh

