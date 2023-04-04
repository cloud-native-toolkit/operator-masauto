#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
CHART_DIR=$(cd "${SCRIPT_DIR}/../charts"; pwd -P)
SAMPLES_DIR=$(cd "${SCRIPT_DIR}/../samples"; pwd -P)

echo "***** Generating ecosystem-engineering-catalog chart"
helm template \
  ecosystem-engineering-catalog \
  "${CHART_DIR}/ecosystem-engineering-catalog" \
  > "${SAMPLES_DIR}/sample_catalog_source.yaml"

echo "***** Generating masauto-operator chart with namespace and entitlement key"
helm template \
  masauto-operator \
  "${CHART_DIR}/masauto-operator" \
  --set create_namespace=true \
  --set ibm_entitlement_key="replace with ibm_entitlement_key" \
  > "${SAMPLES_DIR}/sample_operator_subscription_all.yaml"

echo "***** Generating masauto-operator chart (subscription only)"
helm template \
  masauto-operator \
  "${CHART_DIR}/masauto-operator" \
  --set create_namespace=false \
  --set create_operator_group=false \
  > "${SAMPLES_DIR}/sample_operator_subscription.yaml"

echo "***** Generating mas-core chart"
helm template \
  mas-core \
  "${CHART_DIR}/mas-core" \
  -f "${CHART_DIR}/values_mas_core.yaml" \
  > "${SAMPLES_DIR}/sample_core_cr.yaml"

echo "***** Generating mas-core chart with license"
helm template \
  mas-core \
  "${CHART_DIR}/mas-core" \
  -f "${CHART_DIR}/values_mas_core.yaml" \
  -f "${CHART_DIR}/values_mas_core_license.yaml" \
  > "${SAMPLES_DIR}/sample_core_license_cr.yaml"

echo "***** Generating mas-core chart with cloudflare"
helm template \
  mas-core \
  "${CHART_DIR}/mas-core" \
  -f "${CHART_DIR}/values_mas_core.yaml" \
  -f "${CHART_DIR}/values_mas_core_cloudflare.yaml" \
  > "${SAMPLES_DIR}/sample_core_cloudflare_cr.yaml"

echo "***** Generating mas-manage chart with internal db"
helm template \
  mas-manage \
  "${CHART_DIR}/mas-manage" \
  -f "${CHART_DIR}/values_mas_manage.yaml" \
  > "${SAMPLES_DIR}/sample_manage_cr.yaml"

echo "***** Generating mas-manage chart with external db"
helm template \
  mas-manage \
  "${CHART_DIR}/mas-manage" \
  -f "${CHART_DIR}/values_mas_manage_external_db.yaml" \
  > "${SAMPLES_DIR}/sample_manage_external_db_cr.yaml"
