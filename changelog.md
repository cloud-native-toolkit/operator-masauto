### CHANGE LOG
v1.0.0
- Updates destroy scrip
- Adds comments for requirements prior to running each CR 

v0.12.4 - v0.12.11
- Implementents github workflow automation in module and bundle to automate build/push to quay

v0.12.3
- Removes Masauto API (functionality moved to Core api)

v0.12.2
- Separates DB for manage and monitor/iot

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