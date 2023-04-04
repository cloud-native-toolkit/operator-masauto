#!/usr/bin/env bash

check_k8s_namespace () {
  local NS="$1"

  count=0
  until kubectl get namespace "${NS}" 1> /dev/null 2> /dev/null || [[ $count -eq 60 ]]; do
    echo "Waiting for namespace: ${NS}"
    count=$((count + 1))
    sleep 60
  done

  if [[ $count -eq 60 ]]; then
    echo "Timed out waiting for namespace: ${NS}" >&2
    exit 1
  else
    echo "Found namespace: ${NS}. Sleeping for 30 seconds to wait for everything to settle down"
    sleep 30
  fi
}

check_k8s_resource () {
  local NS="$1"
  local GITOPS_TYPE="$2"
  local NAME="$3"

  echo "Checking for resource: ${NS}/${GITOPS_TYPE}/${NAME}"

  count=0
  local limit=60
  until kubectl get "${GITOPS_TYPE}" "${NAME}" -n "${NS}" 1> /dev/null 2> /dev/null || [[ $count -gt $limit ]]; do
    echo "Waiting for ${GITOPS_TYPE}/${NAME} in ${NS}"
    count=$((count + 1))
    sleep 60
  done

  if [[ $count -gt $limit ]]; then
    echo "Timed out waiting for ${GITOPS_TYPE}/${NAME}" >&2
    kubectl get "${GITOPS_TYPE}" -n "${NS}"
    exit 1
  fi

  kubectl get "${GITOPS_TYPE}" "${NAME}" -n "${NS}" -o yaml

  if [[ "${GITOPS_TYPE}" =~ deployment|statefulset|daemonset ]]; then
    kubectl rollout status "${GITOPS_TYPE}" "${NAME}" -n "${NS}" || exit 1
  elif [[ "${GITOPS_TYPE}" == "job" ]]; then
    kubectl get pods -n "${NS}" | grep "${NAME}"
    local pod_name=$(kubectl get pods -n "${NS}" | grep "${NAME}" | sed -E "s/^([^ ]+).*/\1/g")

    kubectl logs -n "${NS}" "${pod_name}"
    kubectl wait --for=condition=complete "job/${NAME}" -n "${NS}" --timeout=90m || exit 1
  fi

  echo "Done checking for resource: ${NS}/${GITOPS_TYPE}/${NAME}"
}
