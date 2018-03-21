#!/bin/bash

set -euo pipefail
if [ -n "${DEBUG:-}" ] ; then
    set -x
fi

function prepare() {
  echo "Prepare"
}

function run() {
  echo "Run configure script"
  ../configure.sh
}

function verify() {
  echo "Verify results"
  if [[ ! -d $JBOSS_HOME/bin/launch ]]; then
    echo "Missing expected launch folder"
    exit 1
  fi

  files=`find $JBOSS_HOME/bin/launch -type f | wc -l`
  if [[ $files != 7 ]]; then
    echo "Unexpected number of files. Expected 7. Got $files"
    exit 1
  fi
}

prepare

run

verify
