{{/*
Expand the name of the chart.
*/}}
{{- define "masauto-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "masauto-operator.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "masauto-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "masauto-operator.labels" -}}
helm.sh/chart: {{ include "masauto-operator.chart" . }}
{{ include "masauto-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "masauto-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "masauto-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "masauto-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "masauto-operator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "catalog.name" -}}
{{- .Values.catalog_source | default .Values.global.catalog_source | default "ecosystem-engineering-catalog" }}
{{- end }}

{{- define "catalog.namespace" -}}
{{- .Values.catalog_namespace | default .Values.global.catalog_namespace | default "openshift-marketplace" }}
{{- end }}

{{- define "operator.namespace" -}}
{{- .Values.operator_namespace | default .Values.global.operator_namespace | default "masauto-operator-system" }}
{{- end }}

{{- define "mas.ibm_entitlement_secret" -}}
{{- .Values.ibm_entitlement_secret | default .Values.global.ibm_entitlement_secret | default "ibm_entitlement_secret" }}
{{- end }}
