# ecosystem-engineering-catalog chart

Helm chart to install the ecosystem-engineering-catalog CatalogSource into the cluster. By default, the 
CatalogSource will be installed into the `openshift-marketplace` namespace which is the default location
for operator catalogs on Red Hat OpenShift clusters.

The helm chart installs the catalog image (`quay.io/cloudnativetoolkit/ecosysengineer-catalog`) using the
`latest` tag, but the value can be overridden using the `image.tag` value.
