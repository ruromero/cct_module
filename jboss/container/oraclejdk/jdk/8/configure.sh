#!/bin/sh
# Configure module
set -e

SCRIPT_DIR=$(dirname $0)
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts

# OracleJDK - BEGIN
## Remove OpenJDK installed by rh-maven and others
if rpm -q java-1.8.0-openjdk; then
  rpm -e --nodeps $(rpm -qa | grep openjdk)
else
  mkdir -p /usr/lib/jvm/
  chown -R jboss:root /usr/lib/jvm/
fi
## Create openjdk-like alternatives and symlinks
JDK_PATH=/usr/java/jdk1.8.0_211-amd64
JDK_LINKS_PATH=/usr/lib/jvm/java-1.8.0-openjdk

alternatives --install /usr/bin/java java ${JDK_PATH}/jre/bin/java 1
alternatives --install /usr/bin/javac javac ${JDK_PATH}/bin/javac 1
alternatives --install /usr/bin/java_sdk_1.8.0_openjdk java_sdk_1.8.0_openjdk ${JDK_PATH} 1
alternatives --install /usr/bin/java java ${JDK_LINKS_PATH}/jre/bin/java 1
alternatives --install /usr/bin/java_sdk_1.8.0 java_sdk_1.8.0 ${JDK_LINKS_PATH} 1
alternatives --install /usr/bin/java_sdk_openjdk java_sdk_openjdk ${JDK_LINKS_PATH} 1
alternatives --install /usr/bin/jre_1.8.0 jre_1.8.0 ${JDK_LINKS_PATH}/jre 1
alternatives --install /usr/bin/jre_1.8.0_openjdk jre_1.8.0_openjdk ${JDK_LINKS_PATH}/jre 1
alternatives --install /usr/bin/jre_openjdk jre_openjdk ${JDK_LINKS_PATH}/jre 1

alternatives --install /usr/bin/java java ${JDK_PATH}/jre/bin/java 1 \
  --slave /usr/bin/jre jre ${JDK_LINKS_PATH}
alternatives --install /usr/bin/javac javac ${JDK_PATH}/bin/javac 1 \
  --slave /usr/bin/java_sdk java_sdk ${JDK_LINKS_PATH}

ln -s /etc/alternatives/java_sdk /usr/lib/jvm/java
ln -s /etc/alternatives/java_sdk_1.8.0 /usr/lib/jvm/java-1.8.0
ln -s /etc/alternatives/java_sdk_1.8.0_openjdk /usr/lib/jvm/java-1.8.0-openjdk
ln -s /etc/alternatives/java_sdk_openjdk /usr/lib/jvm/java-openjdk
ln -s /etc/alternatives/jre /usr/lib/jvm/jre
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
