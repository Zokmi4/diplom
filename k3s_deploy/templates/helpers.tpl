{{/*
Generate the fullname of the release.
*/}}
{{- define "k3s_deploy.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate a standard name for the chart.
*/}}
{{- define "k3s_deploy.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{/*
Generate labels for the chart.
*/}}
{{- define "k3s_deploy.labels" -}}
app.kubernetes.io/name: {{ include "k3s_deploy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Generate selector labels for the chart.
*/}}
{{- define "k3s_deploy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "k3s_deploy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
