
SUITENAME="$1"
BASNAME="$2"
SLSNAME="$3"
MONGONAME="$4"

NAMESPACE="mas-${SUITENAME}-core"

##
## MAS-Core cleanup script to remove installed resources from gitops deployment
##

# remove argo apps 


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

# remove core
oc delete suite ${SUITENAME} -n ${NAMESPACE}
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
oc delete AnalyticsProxy ${SUITENAME} -n ${BASNAME}
oc delete GenerateKey bas-api-key -n ${BASNAME}
oc delete Dashboard dashboard -n ${BASNAME}
oc delete csv behavior-analytics-services-operator-certified.v1.1.4 -n ${BASNAME}

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


oc delete operandbindinfo ibm-licensing-bindinfo -n ibm-common-services >/dev/null 2>&1 &
resp=$(kubectl get operandbindinfo/ibm-licensing-bindinfo -n ibm-common-services --no-headers 2>/dev/null | wc -l)

if [[ "${resp}" != "0" ]]; then
    echo "patching operandbinding..."
    kubectl patch operandbindinfo/ibm-licensing-bindinfo -p '{"metadata":{"finalizers":[]}}' --type=merge -n ibm-common-services 2>/dev/null
fi

oc delete operandrequest common-service -n ${NAMESPACE} >/dev/null 2>&1 &
resp=$(kubectl get operandrequest/ibm-licensing-bindinfo -n ${NAMESPACE} --no-headers 2>/dev/null | wc -l)

if [[ "${resp}" != "0" ]]; then
    echo "patching operandrequest common-service..."
    kubectl patch operandrequest/common-service -p '{"metadata":{"finalizers":[]}}' --type=merge -n ${NAMESPACE} 2>/dev/null
fi

oc delete operandrequest common-service-cert-manager -n ${NAMESPACE} >/dev/null 2>&1 &
resp=$(kubectl get operandrequest/common-service-cert-manager -n ${NAMESPACE} --no-headers 2>/dev/null | wc -l)

if [[ "${resp}" != "0" ]]; then
    echo "patching operandrequestcommon-service-cert-manager..."
    kubectl patch operandrequest/common-service-cert-manager -p '{"metadata":{"finalizers":[]}}' --type=merge -n ${NAMESPACE} 2>/dev/null
fi


# remove crd's
oc get crd -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep ibm.com | while read crd; do oc delete "crd/$crd"; done
oc get crd -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep cert-manager.io | while read crd; do oc delete "crd/$crd"; done

#remove sls
oc delete licenseservice sls -n ${SLSNAME}
oc delete csv ibm-sls.v3.3.0 -n ${SLSNAME}


#remove jet stack cert-manager if used
#oc delete deployment cert-manager -n cert-manager
#oc delete deployment cert-manager-cainjetor -n cert-manager
#oc delete deployment cert-manager-webhook -n cert-manager
#oc delete namespace cert-manager

#remove namespaces
oc delete namespace ${MONGONAME}
oc delete namespace ${BASNAME}
oc delete namespace ${SLSNAME}
oc delete namespace ibm-common-services
oc delete namespace ${NAMESPACE}
