# Experimental- MAS automation operator

**Defaults to latest v8.8 of MAS**

This creates an operator that will kick off the ansible tasks when passed a CR for whatever MAS component you wish to be installed.
Sample CR's can be found in the `/config/samples` directory.

Present state recommending taking defaults for mas instance name: `inst1` otherwise will need to change the role binding, this will be changed when we move to full OLM / custom catalog install.

Current list of MAS components supported with this operator install:
- Core
- Manage
- IoT
- Monitor
- AppConnect
- CP4D (foundation and services: wsl, wml, spark, aiopenscale, wd)
- Health Predict & Utilities
- Predict

### TO RUN

1.  Add the Ecosystem Engineering catalog to your cluster (see sample catalog source `sample_catalog_source.yaml` in samples directoy)
(note when deploying the operator take the default namespace)

2.  Create a ibm-entitlement-key secret

`oc create secret generic "ibm-entitlement-key" -n masauto-operator-system --from-literal="username=cp" --from-literal="password=<your-ibm-entitlement-key-goes-here>" `

4.  Deploy the operator


### TO DESTROY INSTALL

`./mas-destroy-core.sh inst1 ibm-sls mongoce`


### CHANGE LOG

v0.11.4
- Simplifies the spec for manage add-on deployment

v0.11.3
- Updates operator catalog source sample

v0.11.2
- Updates CP4D sample CRs
- Updates bundle for deployment to quay.io

v0.11.1
- Multiple updates to prepare for release

v0.10.2
- Adds bundle for OLM and custom catalog deployment

v0.9.4
- Service account and rbac updates for multi namespaces

v0.9.0
- Adds Predict deployment

v0.8.2
- Adds Core api (masauto still there for the moment but will be removed)
- Updated CP4D playbook for suite config
- Updated sample CRs

v0.8.1
- Adds read of entitlement key from secret now in all playbooks
- updates samples to support entitlment key secret

v0.8.0
- Adds Health Predict & Utilities deployment

v0.7.0
- Adds CP4D deployment (foundation)
- Adds CP4D services: wsl, wml, spark, aiopenscale, wd

v0.6.0
- Adds AppConnect deployment
- can read secret for ibm-entitlement-key from operator secret OR can pass in CR supports both now

v0.5.0
- Adds Monitor deployment
- Sets reconcile period

v0.4.0
- Adds IoT deployment

v0.3.0
- Adds Manage and DB2 deployment
- start adding sample CR's in the config/samples directory

v0.2.0
- First working version with Core

v0.1.0
- Sets up initial operator scaffolding
- Adds initial core api
