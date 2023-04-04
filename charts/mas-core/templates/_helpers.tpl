{{/*
Expand the name of the chart.
*/}}
{{- define "mas-core.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mas-core.fullname" -}}
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
{{- define "mas-core.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mas-core.labels" -}}
helm.sh/chart: {{ include "mas-core.chart" . }}
{{ include "mas-core.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mas-core.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mas-core.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mas-core.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mas-core.fullname" .) .Values.masLicense.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.masLicense.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "operator.namespace" -}}
{{- .Values.operator_namespace | default .Values.global.operator_namespace | default "masauto-operator-system" }}
{{- end }}

{{- define "mas.ibm_entitlement_secret" -}}
{{- required "The ibm_entitlement_secret value is required" (default .Values.global.ibm_entitlement_secret .Values.ibm_entitlement_secret) }}
{{- end }}

{{- define "mas.mas_instance_id" -}}
{{- .Values.mas_instance_id | default .Values.global.mas_instance_id | default "inst1" }}
{{- end }}

{{- define "mas.mas_workspace_id" -}}
{{- .Values.mas_workspace_id | default .Values.global.mas_workspace_id | default "masdev" }}
{{- end }}
