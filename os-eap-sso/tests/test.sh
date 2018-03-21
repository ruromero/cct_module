#!/bin/bash

set -euo pipefail
if [ -n "${DEBUG:-}" ] ; then
    set -x
fi

TARGET=target

function clean() {
  rm -rf $TARGET
}

while (($#))
do
case $1 in
    --test=*)
      TEST=${1#*=}
      ;;
    --clean)
      clean
      exit 0
      ;;
    *)
      echo Unknown argument $1
      exit 1
      ;;
  esac
  shift
done

tests=${TEST:-`find . -maxdepth 1 -name "*_test.sh" | sort`}
keep_target=${KEEP:-false}

for f in $tests
do
  name=${f%*.sh}
  echo "## START $name test"
  export JBOSS_HOME=$TARGET/$name/opt/eap
  mkdir -p $JBOSS_HOME/standalone/configuration
  ./$f
  echo "## END $name finished successfully"
done
