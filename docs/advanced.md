
## Advanced Setup and Install Scenarios

### Installing Manage with an External DB
When installing Manage with an external db, please follow the steps below before installing Manage.

1.  Create a manage-jdbc-credentials secret.  Note the username will be passed in the manage CR, this is only the password to connect to the database.

`oc create secret generic "manage-jdbc-credentials" -n masauto-operator-system --from-literal="password=<your-jdbc-pw-goes-here>" `

2.  Create a configmap to store your public ssl certificate in pem format for establishing a ssl connection.  This is not required if you set `ssl_enabled: false`, ssl is recommended and true is the default.

`oc -n masauto-operator-system create configmap ca-pemstore --from-file=/temp/db2.pem`  replace the file path and pemfile name with your path and pemfile name.

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