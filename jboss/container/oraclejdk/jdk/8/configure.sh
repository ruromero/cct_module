#!/bin/sh
# Configure module
set -e

SCRIPT_DIR=$(dirname $0)
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts

# OracleJDK - BEGIN
## Remove OpenJDK installed by rh-maven and others
rpm -e --nodeps $(rpm -qa | grep openjdk)
rm /usr/lib/jvm/java-openjdk
ln -s /usr/java/jdk1.8.0_211-amd64 /usr/lib/jvm/java-openjdk

if [ ! $(command -v java) ]; then
  echo "Oracle JDK must be installed manually in the image"
  exit 1
fi

JBOSS_CONTAINER_MODULE=/opt/jboss/container/openjdk/jdk
mkdir -p ${JBOSS_CONTAINER_MODULE}
chown -R jboss:root ${JBOSS_CONTAINER_MODULE}
# OracleJDK - END

chown -R jboss:root $SCRIPT_DIR
chmod -R ug+rwX $SCRIPT_DIR
chmod ug+x ${ARTIFACTS_DIR}/opt/jboss/container/openjdk/jdk/*

pushd ${ARTIFACTS_DIR}
cp -pr * /
popd

echo securerandom.source=file:/dev/urandom >> /usr/lib/jvm/java/jre/lib/security/java.security
