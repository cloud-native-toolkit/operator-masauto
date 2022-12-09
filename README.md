# MAS automation operator

**Defaults to latest v8.8 of MAS**

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


### TO RUN

1.  Add the Ecosystem Engineering catalog to your cluster (see sample catalog source `sample_catalog_source.yaml` in samples directoy)
(note when deploying the operator take the default namespace)

2.  Create a ibm-entitlement-key secret

`oc create secret generic "ibm-entitlement-key" -n masauto-operator-system --from-literal="username=cp" --from-literal="password=<your-ibm-entitlement-key-goes-here>" `

Note: your entitlement key can be found [here](https://myibm.ibm.com/products-services/containerlibrary) 

3.  Deploy the operator


### TO DESTROY INSTALL

`./mas-destroy-core.sh inst1 ibm-sls mongoce`


### CP4D IMPORTANT NOTE
BEFORE installing CP4D you currently must have a *global* pull secret defined on the cluster with your IBM Entitlement Key

