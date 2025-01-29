{{/*
Expand the name of the chart.
*/}}
{{- define "k3s_deploy.fullname" -}}
{{- include "k3s_deploy.name" . }}-{{ .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "k3s_deploy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end -}}
