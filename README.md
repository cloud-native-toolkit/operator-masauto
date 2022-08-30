# Experimental- MAS automation operator

**Defaults to latest v8.8 of MAS**

This creates an operator that will kick off the ansible tasks when passed a CR for whatever MAS component you wish to be installed.
Sample CR's can be found in the `/config/samples` directory.

Present state recommending taking defaults for mas instance name: `inst1` otherwise will need to change the role binding, this will be changed when we move to full OLM / custom catalog install.

Current list of MAS components supported with this install:
- Core
- Manage
- IoT

**TO RUN:**

1.  Clone or download the repo to a local directory, login to openshift cluster via login token
2.  Set IMG var (check out the repo and pick the latest image tag - at time of writing its v0.4.0)

`export IMG=docker.io/tcskill/masauto:v0.4.0`

3.  Install Operator into cluster

`make install deploy`

4.  Customize your CR and install on the cluster (obviously install core CR first, then the others: manage, monitor, etc.)

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
