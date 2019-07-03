#!/bin/sh
# Configure module
set -e

SCRIPT_DIR=$(dirname $0)
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts

# OracleJDK - BEGIN
## Remove OpenJDK installed by rh-maven and others
rpm -e --nodeps $(rpm -qa | grep openjdk)
## Create openjdk-like alternatives and symlinks
JDK_PATH=/usr/java/jdk1.8.0_211-amd64
alternatives --install /usr/bin/java java ${JDK_PATH}/jre/bin/java 1 \
  --slave /usr/bin/java_sdk java_sdk ${JDK_PATH} \
  --slave /usr/bin/java_sdk_1.8.0 java_sdk_1.8.0 ${JDK_PATH} \
  --slave /usr/bin/java_sdk_openjdk java_sdk_openjdk ${JDK_PATH} \
  --slave /usr/bin/java_sdk_1.8.0_openjdk java_sdk_1.8.0_openjdk ${JDK_PATH} \
  --slave /usr/bin/jre_1.8.0 jre_1.8.0 ${JDK_PATH}/jre \
  --slave /usr/bin/jre_openjdk jre_openjdk ${JDK_PATH}/jre

ln -s /etc/alternatives/java_sdk /usr/lib/jvm/java
ln -s /etc/alternatives/java_sdk_1.8.0 /usr/lib/jvm/java-1.8.0
ln -s /etc/alternatives/java_sdk_1.8.0_openjdk /usr/lib/jvm/java-1.8.0-openjdk
ln -s /etc/alternatives/java_sdk_openjdk /usr/lib/jvm/java-openjdk
ln -s /etc/alternatives/jre_1.8.0 /usr/lib/jvm/jre
ln -s /etc/alternatives/jre_1.8.0 /usr/lib/jvm/jre-1.8.0
ln -s /etc/alternatives/jre_openjdk /usr/lib/jvm/jre-openjdk

if [ ! $(command -v java) ]; then
  echo "Oracle JDK must be installed manually in the image"
  exit 1
fi

# OracleJDK - END

chown -R jboss:root $SCRIPT_DIR
chmod -R ug+rwX $SCRIPT_DIR
chmod ug+x ${ARTIFACTS_DIR}/opt/jboss/container/openjdk/jdk/*

pushd ${ARTIFACTS_DIR}
cp -pr * /
popd

echo securerandom.source=file:/dev/urandom >> /usr/lib/jvm/java/jre/lib/security/java.security
