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

**TO RUN:**

1.  Clone or download the repo to a local directory, login to openshift cluster via login token
2.  Set IMG var (check out the repo and pick the latest image tag - at time of writing its v0.10.0)

`export IMG=docker.io/tcskill/masauto:v0.10.0`

3.  Install Operator into cluster and add your entitlement key

`make install deploy`

*IBM Entitlement Key*
Create a secret to hold your ibm entitlement key:

`oc create secret generic "ibm-entitlement-key" -n masauto-operator-system --from-literal="username=cp" --from-literal="password=YOUR-KEY-GOES-HERE"`

4.  Customize your CR and install on the cluster (obviously install core CR first, then the others: manage, iot, monitor, etc.) Sample CR's are foundin the `/config/samples` directory of this repo.

`oc apply -f core_cr.yaml`

5.  Watch the magic! - you can check the progress of the ansible by looking at the operator pod logs

**TO DESTROY INSTALL:**

`./mas-destroy-core.sh inst1 ibm-sls mongoce`


**Change Log**

v0.10.0
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
