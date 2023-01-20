# MAS Install Automation Operator
Currently using MAS Ansible: v12.8.0
![GitHub Workflow Status (with branch)](https://img.shields.io/github/actions/workflow/status/cloud-native-toolkit/operator-masauto/docker-build.yaml)

**This will default to latest v8.9.x of MAS**
(Note: to install older versions of MAS, change the appropriate channel definitions in the CR that is being deployed)

This creates an operator that will run the MAS Product Lab ansible tasks to install MAS and it's applications.

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
- Assist (* see note below on requirements and limitations *)
- Optimizer


### TO RUN

1.  Add the Ecosystem Engineering catalog to your cluster (see sample catalog source `sample_catalog_source.yaml` in samples directoy)
(note when deploying the operator take the default namespace)

2.  Create a ibm-entitlement-key secret

`oc create secret generic "ibm-entitlement-key" -n masauto-operator-system --from-literal="username=cp" --from-literal="password=<your-ibm-entitlement-key-goes-here>" `

Note: your entitlement key can be found [here](https://myibm.ibm.com/products-services/containerlibrary) 

3.  Deploy the operator - search for `Maximo` in the Operator Hub on the cluster and you will see the `Maximo Application Suite Automation operator`

More detailed step by step instructions for deployment using the operator can be found [here](https://github.com/ibm-ecosystem-lab/techzone-assets/blob/main/MAS/1%20-%20TechZone%20Deployment%20Guide%20for%20Maximo%20Operator.pdf)


### CP4D Important Requirement
BEFORE installing CP4D you currently must have a *global* pull secret defined on the cluster with your IBM Entitlement Key

### Predict Important Requirement
If Predict install fails with a configuration error message for the database or database not able to be connected to, then most likely you will need to increase the heap of your db2 MASIOT database.  You can edit the following: CustomResourceDefination-> Db2Cluster->Instances->MASIOT  in the yaml edit the pod resources limits section set cpu:8 and mem: 32Gi

### Assist Important Requirement
Assist requires object storage (for Watson Discovery).  For a Watson Discovery install ensure you have a properly sized cluster.  If you plan on installing the entire stack here, you will need a minimum of 12 worker nodes, 16x64 on the vpc.

**VERY IMPORTANT**  

By Default the Assist install will install: cos, cpd/discovery, and Assist App.  It will not apply the configurations in MAS for cos or discovery, and will not activate the AssistWorkspace. This is due to the issue below.  You can activate Assist manually in the MAS UI, or you can set `activate_app="true"` and add the root cert as described below.

The current product lab ansible does not handle the creation of the objectstoragecfg CR certificate correctly.  It leaves the root certificate in the chain out.  This must be added manually right now to the objectstoragecfg CR to create the full certificate chain.  This root cert can be obtained from simply opening the url for the object storage referenced in the error - open that in a browser and download the root cert then add that in the CR or open the MAS UI config for object storage and add it there.


### TO DESTROY INSTALL
(this currently destroys a core install only)
`./mas-destroy-core.sh inst1 ibm-sls mongoce`

