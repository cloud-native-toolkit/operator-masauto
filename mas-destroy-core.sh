
SUITENAME="$1"
BASNAME="ibm-common-services"
SLSNAME="$2"
MONGONAME="$3"

#checks for params
if [ $# -ne 3 ]
  then
    echo "Usage: ./mas-destroy-core.sh <mas-suite-name> <sls-namespace> <mongo-namespace>"
    exit 0
fi

NAMESPACE="mas-${SUITENAME}-core"

##
## MAS-Core cleanup script to remove installed resources from gitops deployment
##

#remove the CR from the MAS Automation operator
oc delete core masauto-core -n masauto-operator-system

#remove ibm common services
oc delete operandconfig common-service -n ibm-common-services
oc delete operand registry common-service -n ibm-common-services
oc delete csv operand-deployment-lifecycle-manager.v1.17.1 -n ibm-common-services

oc delete namespacescope odlm-scope-managedby-odlm -n ibm-common-services
oc delete namespacescope nss-odlm-scope -n ibm-common-services
oc delete namespacescope nss-managedby-odlm -n ibm-common-services
oc delete namespacescope common-service -n ibm-common-services
oc delete csv ibm-namespace-scope-operator.v1.13.1 -n ibm-common-services

oc delete commonservice common-service -n ibm-common-services
oc delete csv ibm-common-service-operator.v3.15.1 -n ibm-common-services

oc -n kube-system delete secret icp-metering-api-secret 
oc -n kube-public delete configmap ibmcloud-cluster-info
oc -n kube-public delete secret ibmcloud-cluster-ca-cert
oc delete ValidatingWebhookConfiguration cert-manager-webhook ibm-cs-ns-mapping-webhook-configuration --ignore-not-found
oc delete MutatingWebhookConfiguration cert-manager-webhook ibm-common-service-webhook-configuration ibm-operandrequest-webhook-configuration namespace-admission-config --ignore-not-found
oc delete namespace services
oc delete nss --all

# remove core suite - it will most likely hang so remove finalizer
oc delete suite ${SUITENAME} -n ${NAMESPACE} >/dev/null 2>&1 &
resp=$(kubectl get suite ${SUITENAME} -n ${NAMESPACE} --no-headers 2>/dev/null | wc -l)

if [[ "${resp}" != "0" ]]; then
    echo "patching suite..."
    kubectl patch suite/${SUITENAME} -p '{"metadata":{"finalizers":[]}}' --type=merge -n ${NAMESPACE} 2>/dev/null
fi

# remove core workspace - assume default install using masdev as workspace name
oc delete workspace ${SUITENAME}-masdev -n ${NAMESPACE} >/dev/null 2>&1 &
resp=$(kubectl get workspace ${SUITENAME}-masdev -n ${NAMESPACE} --no-headers 2>/dev/null | wc -l)

if [[ "${resp}" != "0" ]]; then
    echo "patching workspace..."
    kubectl patch workspace/${SUITENAME}-masdev -p '{"metadata":{"finalizers":[]}}' --type=merge -n ${NAMESPACE} 2>/dev/null
fi

oc delete csv ibm-mas.v8.8 -n ${NAMESPACE}

# remove truststore and dependencies
oc delete csv ibm-truststore-mgr.v1.2.2 -n ${NAMESPACE}
oc delete truststore ${SUITENAME}-truststore -n ${NAMESPACE} >/dev/null 2>&1 &

# In the case that Kubernetes hangs on truststore instances, set the finalizer to null which will force delete, issue with operator
resp=$(kubectl get truststore/${SUITENAME}-truststore -n ${NAMESPACE} --no-headers 2>/dev/null | wc -l)

if [[ "${resp}" != "0" ]]; then
    echo "patching truststore..."
    kubectl patch truststore/${SUITENAME}-truststore -p '{"metadata":{"finalizers":[]}}' --type=merge -n ${NAMESPACE} 2>/dev/null
fi

oc delete truststore ${SUITENAME}-coreidp-truststore -n ${NAMESPACE} >/dev/null 2>&1 &
resp=$(kubectl get truststore/${SUITENAME}-coreidp-truststore -n ${NAMESPACE} --no-headers 2>/dev/null | wc -l)

if [[ "${resp}" != "0" ]]; then
    echo "patching truststore..."
    kubectl patch truststore/${SUITENAME}-coreidp-truststore -p '{"metadata":{"finalizers":[]}}' --type=merge -n ${NAMESPACE} 2>/dev/null
fi


#remove mongo
oc delete deployment mongodb-kubernetes-operator -n ${MONGONAME}

#remove bas
oc delete AnalyticsProxy analyticsproxy -n ${BASNAME}
oc delete GenerateKey uds-api-key -n ${BASNAME}
oc delete Dashboard dashboard -n ${BASNAME}
oc delete csv postgresoperator.v5.1.3 -n ${BASNAME}

oc delete deployment amq-streams-cluster-operator-v1.7.3 -n ${BASNAME}

oc delete deployment event-api-deployment -n ${BASNAME}
oc delete deployment event-reader-deployment -n ${BASNAME}
oc delete deployment grafana-deployment -n ${BASNAME}
oc delete deployment instrumentationdb -n ${BASNAME}
oc delete deployment instrumentationdb-backrest-shared-repo -n ${BASNAME}
oc delete deployment kafka-entity-operator -n ${BASNAME}
oc delete deployment postgres-operator -n ${BASNAME}
oc delete deployment simple-reverse-proxy -n ${BASNAME}
oc delete deployment store-api-deployment -n ${BASNAME}


# remove operator binding info CR's
oc delete operandbindinfo ibm-uds-bindinfo -n ibm-common-services >/dev/null 2>&1 &
resp=$(kubectl get operandbindinfo/ibm-uds-bindinfo -n ibm-common-services --no-headers 2>/dev/null | wc -l)

if [[ "${resp}" != "0" ]]; then
    echo "patching operandbinding..."
    kubectl patch operandbindinfo/ibm-uds-bindinfo -p '{"metadata":{"finalizers":[]}}' --type=merge -n ibm-common-services 2>/dev/null
fi

oc delete operandrequest common-service -n ibm-common-services  >/dev/null 2>&1 &
resp=$(kubectl get operandrequest/common-service -n ibm-common-services --no-headers 2>/dev/null | wc -l)

if [[ "${resp}" != "0" ]]; then
    echo "patching operandrequest common-service..."
    kubectl patch operandrequest/common-service -p '{"metadata":{"finalizers":[]}}' --type=merge -n ibm-common-services 2>/dev/null
fi

oc delete operandrequest common-service -n ${NAMESPACE} >/dev/null 2>&1 &
resp=$(kubectl get operandrequest/common-service -n ${NAMESPACE} --no-headers 2>/dev/null | wc -l)

if [[ "${resp}" != "0" ]]; then
    echo "patching operandrequest common-service..."
    kubectl patch operandrequest/common-service -p '{"metadata":{"finalizers":[]}}' --type=merge -n ${NAMESPACE} 2>/dev/null
fi

oc delete operandrequest events-operator-request -n ibm-common-services >/dev/null 2>&1 &
resp=$(kubectl get operandrequest/events-operator-request -n ibm-common-services --no-headers 2>/dev/null | wc -l)

if [[ "${resp}" != "0" ]]; then
    echo "patching operandrequest events-operator-request..."
    kubectl patch operandrequest/events-operator-request -p '{"metadata":{"finalizers":[]}}' --type=merge -n ibm-common-services 2>/dev/null
fi

oc delete operandrequest user-data-services -n ibm-common-services >/dev/null 2>&1 &
resp=$(kubectl get operandrequest/user-data-services -n ibm-common-services --no-headers 2>/dev/null | wc -l)

if [[ "${resp}" != "0" ]]; then
    echo "patching operandrequest user-data-services..."
    kubectl patch operandrequest/user-data-services -p '{"metadata":{"finalizers":[]}}' --type=merge -n ibm-common-services 2>/dev/null
fi

oc delete operandbindinfo ibm-licensing-bindinfo -n ibm-common-services >/dev/null 2>&1 &
resp=$(kubectl get operandbindinfo/ibm-licensing-bindinfo -n ibm-common-services --no-headers 2>/dev/null | wc -l)

if [[ "${resp}" != "0" ]]; then
    echo "patching operandbindinfo ibm-licensing-bindinfo..."
    kubectl patch operandbindinfo/ibm-licensing-bindinfo -p '{"metadata":{"finalizers":[]}}' --type=merge -n ibm-common-services 2>/dev/null
fi

oc delete operandregistry common-service -n ibm-common-services >/dev/null 2>&1 &
resp=$(kubectl get operandregistry/common-service -n ibm-common-services --no-headers 2>/dev/null | wc -l)

if [[ "${resp}" != "0" ]]; then
    echo "patching operandregistry common-service..."
    kubectl patch operandregistry/common-service -p '{"metadata":{"finalizers":[]}}' --type=merge -n ibm-common-services 2>/dev/null
fi

oc delete slscfg ${SUITENAME}-sls-system -n ${NAMESPACE} >/dev/null 2>&1 &
resp=$(kubectl get slscfg/${SUITENAME}-sls-system -n ${NAMESPACE} --no-headers 2>/dev/null | wc -l)

if [[ "${resp}" != "0" ]]; then
    echo "patching slscfg..."
    kubectl patch slscfg/${SUITENAME}-sls-system -p '{"metadata":{"finalizers":[]}}' --type=merge -n ${NAMESPACE} 2>/dev/null
fi

# remove crd's
oc get crd -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep ibm.com | while read crd; do oc delete "crd/$crd"; done
oc get crd -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep cert-manager.io | while read crd; do oc delete "crd/$crd"; done

#remove sls
oc delete licenseservice sls -n ${SLSNAME}
oc delete csv ibm-sls.v3.4.1 -n ${SLSNAME}


#remove namespaces
oc delete namespace ${MONGONAME}
oc delete namespace ${BASNAME}
oc delete namespace ${SLSNAME}
oc delete namespace ibm-common-services
oc delete namespace ${NAMESPACE}
