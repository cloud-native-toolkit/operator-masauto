# mas-core chart

Helm chart to install the MAS Core resource into the the cluster. Optionally, the chart will also configure
the license for the MAS Core instance if the license information is provided.

| Name                       | Description                                                                  | Default                 |
|----------------------------|------------------------------------------------------------------------------|-------------------------|
| ibm_entitlement_secret     | The name of the secret containing the IBM entitlement key                    | ""                      |
| mas_instance_id            | The id of the MAS instance                                                   | inst1                   |
| mas_workspace_id           | The id of the workspace                                                      | masdev                  |
| operator_namespace         | The namespace where the operator has been installed                          | masauto-operator-system |
| mas_channel                | The channel from which the MAS core operator should be installed             | 8.10.x                  |
| nas_workspace_name         | The formatted name of the workspace                                          | MAS Development         |
| mongodb_storage_class      | The RWX storage class that will be used for the MongoDB database             |                         |
| uds_storage_class          | The RWX storage class that will be used for the UDS volume                   |                         |
| uds_contact_email          | The email address of the contact person for UDS                              |                         |
| uds_contact_firstname      | The first name of the contact person for UDS                                 |                         |
| uds_contact_lastname       | The last name of the contact person for UDS                                  |                         |
| masLicense.secretName      | The name of the secret containing the host id and license for MAS            |                         |
| masLicense.targetNamespace | The namespace where the SLS instance is running                              |                         |
| masLicense.serviceAccount  | The information about the service account required to create the license job |                         |
| mas_annotations            | The annotations that should be added to the MAS Core instance                |                         |
