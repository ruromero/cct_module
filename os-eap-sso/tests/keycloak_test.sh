#!/bin/bash


CONFIG_FILE=$JBOSS_HOME/standalone/configuration/standalone-openshift.xml

function prepare() {
  echo "Prepare"
  ../configure.sh
  cp -r resources/keycloak_01/standalone $JBOSS_HOME
  cp resources/standalone-openshift.xml.orig $CONFIG_FILE

  # External dependency os-logging
  mkdir -p $JBOSS_HOME/bin/launch
  cp ../../os-logging/added/launch/logging.sh $JBOSS_HOME/bin/launch
}

function run() {
  echo "Run configure script"
  source $JBOSS_HOME/bin/launch/keycloak.sh
  configure
}

function verify() {
  echo "Verify results"
  xmllint $CONFIG_FILE > /dev/null
  if [ $? -ne 0 ]; then
    echo "Invalid resulting XML"
    exit 1
  fi
}

prepare

run

verify
