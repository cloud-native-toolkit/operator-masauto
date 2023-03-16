### Setup Prior to installing Manage with an External DB
When installing Manage with an external db, please follow the steps below before installing Manage.

1.  Create a manage-jdbc-credentials secret.  Note the username will be passed in the manage CR, this is only the password to connect to the database.

`oc create secret generic "manage-jdbc-credentials" -n masauto-operator-system --from-literal="password=<your-jdbc-pw-goes-here>" `

2.  Create a configmap to store your public ssl certificate in pem format for establishing a ssl connection.  This is not required if you set `ssl_enabled: false`, ssl is recommended and true is the default.

`oc -n masauto-operator-system create configmap ca-pemstore --from-file=/Users/temp/db2.pem`  replace the file path and pemfile name with your path and pemfile name.