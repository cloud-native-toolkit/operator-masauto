# Experimental- MAS automation operator

**Defaults to latest v8.8 of MAS**

This creates an operator that will kick off the ansible tasks when passed a CR for whatever MAS component you wish to be installed.
Sample CR's can be found in the `/config/samples` directory.

Present state recommending taking defaults for mas instance name: `inst1` otherwise will need to change the role binding, this will be changed when we move to full OLM / custom catalog install.

Current list of MAS components supported with this install:
- Core
- Manage
- IoT
- Monitor
- AppConnect

**TO RUN:**

1.  Clone or download the repo to a local directory, login to openshift cluster via login token
2.  Set IMG var (check out the repo and pick the latest image tag - at time of writing its v0.7.0)

`export IMG=docker.io/tcskill/masauto:v0.7.0`

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

**TO DO:**
- Add other MAS app playbooks/api's
- Determine best defaults to set for manage components var: mas_appws_components
- Add OLM, custom catalog
- Update Core CRD to reflect Core in the Kind
- Update role binding to instance variable instead of default inst1
- Add destroy script for other apps (core only right now)

**Change Log**
v0.7.0
- Adds CP4D deployment

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


