#!/bin/bash

set -e -u

echo "mock unit test suite"

function status () {
  exitcode=$?
  echo "cleanup function with exit code: $exitcode"
  if [ $exitcode -eq 0 ]; then
    state="success"
  else
    state="failure"
  fi
  PAYLOAD="{\"state\": \"$state\", \"id\": \"$CODEBUILD_BUILD_ID\", \"region\": \"$AWS_REGION\"}"

  echo $PAYLOAD
  echo
  curl -XPOST --verbose --data "$PAYLOAD" "https://api.deploytoproduction.com/status"

  echo "exiting with code $exitcode"
  exit $exitcode
}

trap "status" INT TERM EXIT

echo "mock successful tests" && exit 0
# echo "mock failing tests" && exit 1
