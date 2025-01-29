{{/*
Generate the fullname of the release.
*/}}
{{- define "diplom.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate a standard name for the chart.
*/}}
{{- define "diplom.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{/*
Generate labels for the chart.
*/}}
{{- define "diplom.labels" -}}
app.kubernetes.io/name: {{ include "diplom.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Generate selector labels for the chart.
*/}}
{{- define "diplom.selectorLabels" -}}
app.kubernetes.io/name: {{ include "diplom.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
