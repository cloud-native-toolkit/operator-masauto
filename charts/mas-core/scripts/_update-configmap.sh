#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
SUPPORT_DIR=$(cd "${SCRIPT_DIR}/../support"; pwd -P)
TEMPLATE_DIR=$(cd "${SCRIPT_DIR}/../templates"; pwd -P)

cat "${SUPPORT_DIR}/configmap.snippet.yaml" > "${TEMPLATE_DIR}/configmap.yaml"

oc create configmap tmp \
  --from-file=${SCRIPT_DIR}/copy-secret.sh \
  --from-file=${SCRIPT_DIR}/helper-functions.sh \
  --dry-run=client \
  -o yaml | \
yq eval 'del(.apiVersion) | del(.kind) | del(.metadata)' - >> "${TEMPLATE_DIR}/configmap.yaml"

echo "{{- end }}" >> "${TEMPLATE_DIR}/configmap.yaml"
