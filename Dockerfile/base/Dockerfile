FROM java:8

# This image provides a JAVA environment and scripts to build Atlassian Confluence.

MAINTAINER BinaryBabel OSS <code-czar@binbab.org>

ENV INSTALL_PATH /opt

EXPOSE 8080

LABEL io.k8s.description="Platform for Atlassian Confluence 5" \
      io.k8s.display-name="Atlassian Confluence 5" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="java,atlassian,confluence" \
      io.openshift.non-scalable="true"

ENV MYSQL_CONN_VERSION 5.1.37
ENV JAVA_VERSION 8u60-b27

RUN ["/bin/bash", "-c", "set -x \

    # Install required tools.
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
       wget \
       tar \
       unzip \
       python-setuptools \
    && apt-get clean \

    # Install S3CMD (For importing large backups.)
    && pushd /usr/local/src \
    && wget -O s3cmd-master.zip https://github.com/s3tools/s3cmd/archive/master.zip \
    && unzip s3cmd-master.zip \
    && pushd s3cmd-master \
    && python setup.py install \
    && popd \
    && rm -Rf s3cmd-master* \
    && popd \

    # Install MySQL Connector
    && pushd /usr/local/src \
    && wget --no-check-certificate http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_CONN_VERSION}.tar.gz \
    && tar -xzf mysql-connector-java-${MYSQL_CONN_VERSION}.tar.gz \
    && mv mysql-connector-java-${MYSQL_CONN_VERSION}/mysql-connector-java-${MYSQL_CONN_VERSION}-bin.jar /usr/lib \
    && rm -Rf mysql-connector-java-* \
    && popd \

    # Prepare install path for use by OpenShift.
    && mkdir -p $INSTALL_PATH \
    && chmod 777 $INSTALL_PATH \

"]

USER 1001
WORKDIR $INSTALL_PATH
COPY launch-confluence.sh server.xml $INSTALL_PATH/
ENTRYPOINT $INSTALL_PATH/launch-confluence.sh
