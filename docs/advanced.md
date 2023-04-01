
## Advanced Setup and Install Scenarios

### Installing Manage with an External DB
When installing Manage with an external db, please follow the steps below before installing Manage.

1.  Create a manage-jdbc-credentials secret.  Note the username will be passed in the manage CR, this is only the password to connect to the database.

```shell
oc create secret generic "manage-jdbc-credentials" -n masauto-operator-system --from-literal="password=<your-jdbc-pw-goes-here>"
```

2.  Create a configmap to store your public ssl certificate in pem format for establishing a ssl connection.  This is not required if you set `ssl_enabled: false`, ssl is recommended and true is the default.

```shell
oc -n masauto-operator-system create configmap ca-pemstore --from-file=/temp/db2.pem
```
replace the file path and pemfile name with your path and pemfile name.

### Installing multiple instances of MAS and Applications
Multiple instances of core as well as the applications are supported.  It is not uncommon in a development cluster to install multiple instance of Manage for example while sharing common services of: mongo, sls, UDS among the core instances.

This can be done simply through editing the yaml in the core or appliation CR before deployment.  To deploy a second core instance, simply change the name of the mas_instance_id variable to something different than the first instance already deploy.  For example if `inst1` is already deployed on the cluster, change this to `inst2` as shown below.

```shell
   name: masauto-core2
   mas_instance_id: "inst2"
```   

The same applies for installing a second Manage on the same cluster.  A sample of the variables needed to be changed could look something like below.

```shell
  name: masauto-manage2
  mas_instance_id: "inst2"
  db2_instance_name: "db2w-manage2"
```

### Using a DNS with Core and Signing with Letsencrypt Service
Current automation supports both IBM CIS or Cloudflare DNS.  This automation operator requires your apikey for either service to be in a secret on the cluster.  Set this up before running an installation of Core.

1. If using Cloudflare:

```shell
  oc create secret generic "cloudflare-apitoken-secret" -n masauto-operator-system --from-literal="apitoken=<your-apitoken-goes-here>"
``` 

2. If using IBM CIS:

```shell
  oc create secret generic "cis-apikey-secret" -n masauto-operator-system --from-literal="apikey=<your-apikey-goes-here>"
```

3.  See the samples [directory](/samples) for a sample core CR with either CIS or Cloudflare DNS and letsencrypt.

### Automating the App Point License apply during Install
IBM SLS Supports the concept of bootstrapping SLS with a license key that is already defined before installing MAS Core. This allows SLS to apply the license and this automation operator to apply the license to core during the install - fully automated so you do not have to drag/drop the license in the UI after a Core install to activate the product.  Before installing Core, follow these steps:

1. Create a project namespace on your cluster called: `ibm-sls`
2. Create a bootstrap secret our of your license.dat file and apply this to your cluster.

The secret below is for illustrative purpose only. This secret won't actually work, you need to copy/paste **YOUR** license.dat (app point license from IBM License Center) content into a secret in this form:

```shell
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: sls-bootstrap
  namespace: ibm-sls
stringData:
  licensingId: "<yourhostID>"
  licensingKey: |
    SERVER ibm-sls <yourhostID> 27000
    VENDOR ibmratl
    VENDOR telelogic
    VENDOR rational
    INCREMENT AppPoints ibmratl 1.0 15-jan-2023 5 vendor_info="0|IBM \
      Maximo AppPoints Pool|0" ISSUED=24-May-2022 NOTICE="Sales \
      Order Number:IBM_1234567890;Account ID:IBM \
```

Help on defining a hostID as well as generating a license.dat file from the IBM License center can be found [here](https://www.ibm.com/docs/en/mas-cd/continuous-delivery?topic=environment-installation-prerequisites)

3. After you apply the new secret on your cluster, install Core