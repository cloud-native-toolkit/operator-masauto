# Maximo Application Suite (MAS) Install Automation OpenShift Operator
Currently using MAS Ansible: v12.9.2

![GitHub Workflow Status (with branch)](https://img.shields.io/github/actions/workflow/status/cloud-native-toolkit/operator-masauto/docker-build.yaml) ![GitHub Release Date](https://img.shields.io/github/release-date/cloud-native-toolkit/operator-masauto)

**This will default to latest v8.9.x of MAS**
(Note: to install older versions of MAS, change the appropriate channel definitions in the CR that is being deployed)

This creates an operator that will run the MAS Product Lab ansible tasks to install MAS and it's applications.  Present state recommending taking defaults for mas instance name: `inst1` otherwise will need to change the role binding.  Other suitable defaults are provided in the [samples](/samples) directory and the operator CR's.

Current list of MAS components supported with this operator install as well as recommended order if installing the stack:
- Core
- Manage
- IoT
- Monitor
- AppConnect
- CP4D (**see note below** -  foundation and services: wsl, wml, spark, aiopenscale, wd)
- Predict
- Health Predict & Utilities
- Assist (**see note below** for requirements and limitations)
- Optimizer

### Pre-install Requirements
MAS requires RWX storage on your cluster.  We test with ODF / OCS but other storage options are supported and can be found with other cluster requirements on the product [documentation](https://www.ibm.com/docs/en/mas-cd/continuous-delivery?topic=installing)

### To Run

1.  Add the Ecosystem Engineering catalog to your cluster (see sample catalog source `sample_catalog_source.yaml` in samples directoy)
(note when deploying the operator take the default namespace)

2.  Deploy the operator and take the default namespace - search for `Maximo` in the Operator Hub on the cluster and you will see the `Maximo Application Suite Automation operator`

3.  Create a ibm-entitlement-key secret

`oc create secret generic "ibm-entitlement-key" -n masauto-operator-system --from-literal="username=cp" --from-literal="password=<your-ibm-entitlement-key-goes-here>" `
Note: your entitlement key can be found [here](https://myibm.ibm.com/products-services/containerlibrary) 

4.  When deploying any of the applications, it is best to use the **yaml** view on the operator page so you can edit the storage classes appropriately for your cluster and cloud platform.  You may need to add the cluster ingress certificate secret name to the yaml file before you deploy.  See the **Troubleshooting** section below under ingress.

More detailed step by step instructions for deployment using the operator can be found [here](/docs/MAS-Operator-Deployment.pdf)

### CP4D Important Requirement
BEFORE installing CP4D you currently must have a *global* pull secret defined on the cluster with your IBM Entitlement Key

### Assist Important Requirement
Assist requires object storage (for Watson Discovery).  For a Watson Discovery install ensure you have a properly sized cluster.  If you plan on installing the entire stack here, you will need a minimum of 12 worker nodes, 16x64 on the vpc.

**VERY IMPORTANT for Assist**  

By Default the Assist install will install: cos, cpd/discovery, and Assist App.  It will not apply the configurations in MAS for cos or discovery, and will not activate the AssistWorkspace. This is due to the issue below.  You can activate Assist manually in the MAS UI, or you can set `activate_app="true"` and add the root cert as described below.

The current product lab ansible does not handle the creation of the objectstoragecfg CR certificate correctly.  It leaves the root certificate in the chain out.  This must be added manually right now to the objectstoragecfg CR to create the full certificate chain.  This root cert can be obtained from simply opening the url for the object storage referenced in the error - open that in a browser and download the root cert then add that in the CR or open the MAS UI config for object storage and add it there.

### To Destory a Core Install
(this currently destroys a core install only)
`./mas-destroy-core.sh inst1 ibm-sls mongoce`

### Troubleshooting
Check for errors in the log for this operator pod running in the `masauto-operator-system` namespace


**Various IBM Common Service operators stuck not able to install**  
This is currently being reported for installs on IBM Cloud, ROKS v4.10.x and is due to a reported RedHat OLM [bug](https://issues.redhat.com/projects/RHIBMCS/issues/RHIBMCS-147?filter=allopenissues) where the catalog source seems to be removed during the operator install. If you go into the subscription for the operator, look at the yaml for the status, you should see it complaining about a csv. One possible work around is to delete that csv and wait a few mins.  The operator will then pick up and re-install properly.  You may also have to delete the subscription.  Here's an example of how to delete a troubled csv:  `oc delete csv ibm-events-operator.v4.2.1 -n ibm-common-services`


**Install of an application or core fails with an error about ingress tls**

An install fails with an error about `cluster_ingress_secret_name`
Depending on how the cluster is installed, the ingress secret name may need to be shared
with this operator during the install.

Fix: When installing core and all apps, add the following parameter to the yaml CR before creating a
core instance (example shown here is for using letsencrypt yours may be different): 

`ocp_ingress_tls_secret_name: "letsencrypt-certs"` 

Replace letsencrypt with your cluster secret name usually found in the `openshift-ingress` namespace of the cluster.
