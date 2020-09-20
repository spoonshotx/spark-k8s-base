# Dependencies Container Image
# Install wget to retrieve Spark runtime components,
# extract to temporary directory, copy to the desired image
FROM openjdk:8-jdk-slim

ARG spark_uid=185

RUN set -ex && \
    apt-get update && \
    ln -s /lib /lib64 && \
    apt install -y bash tini libc6 libpam-modules libnss3 wget python3 python3-pip && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    ln -sv /usr/bin/tini /sbin/tini && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
    ln -sv /usr/bin/python3 /usr/bin/python && \
    ln -sv /usr/bin/pip3 /usr/bin/pip \
    rm -rf /var/cache/apt/*

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt install -yqq krb5-user \
  && rm -rf /var/cache/apt/*

WORKDIR /opt/

ADD https://archive.apache.org/dist/spark/spark-2.4.6/spark-2.4.6-bin-hadoop2.7.tgz .
RUN tar xvzf spark-2.4.6-bin-hadoop2.7.tgz

RUN ln -s /opt/spark-2.4.6-bin-hadoop2.7 /opt/spark \
    && cp /opt/spark/kubernetes/dockerfiles/spark/entrypoint.sh /opt/


WORKDIR /opt/spark/work-dir
RUN chmod g+w /opt/spark/work-dir

RUN apt install -y apt-transport-https apt-utils gnupg curl \
  && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
  && apt update \
  && apt install -y kubectl

# https://github.com/fabric8io/kubernetes-client/issues/2212
ENV HTTP2_DISABLE=true

WORKDIR /tmp
RUN cd /tmp \
  && export KUBERNETES_CLIENT_VERSION=4.6.4 \
  && wget https://repo1.maven.org/maven2/io/fabric8/kubernetes-client/${KUBERNETES_CLIENT_VERSION}/kubernetes-client-${KUBERNETES_CLIENT_VERSION}.jar \
  && wget https://repo1.maven.org/maven2/io/fabric8/kubernetes-model/${KUBERNETES_CLIENT_VERSION}/kubernetes-model-${KUBERNETES_CLIENT_VERSION}.jar \
  && wget https://repo1.maven.org/maven2/io/fabric8/kubernetes-model-common/${KUBERNETES_CLIENT_VERSION}/kubernetes-model-common-${KUBERNETES_CLIENT_VERSION}.jar \
  && rm -rf /opt/spark/jars/kubernetes-client-* \
  && rm -rf /opt/spark/jars/kubernetes-model-* \
  && rm -rf /opt/spark/jars/kubernetes-model-common-* \
  && mv /tmp/kubernetes-* /opt/spark/jars/

# Set Spark runtime options
ENV SPARK_HOME /opt/spark

WORKDIR /opt/spark/work-dir

ENTRYPOINT [ "/opt/entrypoint.sh" ]

MAINTAINER Mainteiner <email@example.com>

# Specify the User that the actual main process will run as
USER ${spark_uid}
