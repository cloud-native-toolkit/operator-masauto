#!/bin/bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

source "${SCRIPT_DIR}/helper-functions.sh"

if [[ -z "${NAMESPACE}" ]]; then
  echo "NAMESPACE not set" &>2
  exit 1
fi

if [[ -z "${CURRENT_NAMESPACE}" ]]; then
  echo "CURRENT_NAMESPACE not set" &>2
  exit 1
fi

if [[ -z "${SECRET_NAME}" ]]; then
  echo "SECRET_NAME not set" &>2
  exit 1
fi

if [[ -z "${TARGET_SECRET}" ]]; then
  TARGET_SECRET="sls-bootstrap"
fi

set -ex

# wait for secret
check_k8s_resource "${CURRENT_NAMESPACE}" secret "${SECRET_NAME}" || exit 1

# wait for namespace
check_k8s_namespace "${NAMESPACE}" || exit 1

oc get secret "${SECRET_NAME}" -o json | \
  jq --arg NS "${NAMESPACE}" --arg NAME "${TARGET_SECRET}" '{"apiVersion":.apiVersion,"type":.type,"kind":.kind,"metadata":{"name":$NAME,"namespace":$NS},"data":.data}' | \
  oc apply -f -
