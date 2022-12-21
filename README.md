# MAS automation operator

(currently using MAS Ansible v12.3.1)

**This will default to latest v8.8 of MAS**
(Full MAS 8.9 support expected with MAS v8.9.1 release GA)

This creates an operator that will kick off the ansible tasks when passed a CR for whatever MAS component you wish to be installed.
Sample CR's can be found in the `/config/samples` directory.

Present state recommending taking defaults for mas instance name: `inst1` otherwise will need to change the role binding, this will be changed when we move to full OLM / custom catalog install.

Current list of MAS components supported with this operator install as well as recommended order if installing the stack:
- Core
- Manage
- IoT
- Monitor
- AppConnect
- CP4D (* see note below * - foundation and services: wsl, wml, spark, aiopenscale, wd)
- Predict
- Health Predict & Utilities
- Assist (* see note below on requirements *)


### TO RUN

1.  Add the Ecosystem Engineering catalog to your cluster (see sample catalog source `sample_catalog_source.yaml` in samples directoy)
(note when deploying the operator take the default namespace)

2.  Create a ibm-entitlement-key secret

`oc create secret generic "ibm-entitlement-key" -n masauto-operator-system --from-literal="username=cp" --from-literal="password=<your-ibm-entitlement-key-goes-here>" `

Note: your entitlement key can be found [here](https://myibm.ibm.com/products-services/containerlibrary) 

3.  Deploy the operator


### TO DESTROY INSTALL

`./mas-destroy-core.sh inst1 ibm-sls mongoce`


### CP4D Important Requirement
BEFORE installing CP4D you currently must have a *global* pull secret defined on the cluster with your IBM Entitlement Key

### Predict Important Requirement
If Predict install fails with a configuration error message for the database or database not able to be connected to, then most likely you will need to increase the heap of your db2 MASIOT database.  You can edit the following: CustomResourceDefination-> Db2Cluster->Instances->MASIOT  in the yaml edit the pod resources limits section set cpu:8 and mem: 32Gi

### Assist Important Requirement
Assist requires object storage (for Watson Discovery).  For a Watson Discovery install ensure you have a properly sized cluster.  If you plan on installing the entire stack here, you will need a minimum of 12 worker nodes, 16x64 on the vpc.

IMPORTANT:  The current product ansible does not handle the creation of the objectstoragecfg CR certificate correctly.  It leaves the root certificate in the chain out.  This must be added manually right now to the objectstoragecfg CR to create the full certificate chain.  This root cert can be obtained from simply opening the url for the object storage referenced in the error - opent that in a browser and download the root cert then add that in the CR or open the MAS UI config for object storage and add it there.
