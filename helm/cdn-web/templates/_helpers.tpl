{{/*
Expand the name of the chart.
*/}}
{{- define "cdn-web.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cdn-web.fullname" -}}
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
{{- define "cdn-web.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cdn-web.labels" -}}
helm.sh/chart: {{ include "cdn-web.chart" . }}
{{ include "cdn-web.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cdn-web.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cdn-web.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cdn-web.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cdn-web.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "cdn-web.envValue" -}}
{{- if not (index .Values.env .key) }}
{{- if or (not .secret) (not .secret.data) }}
{{- required (printf "env.%s iis required." .key) (index .Values.env .key) }}
{{- else }}
{{- index .secret.data .key }}
{{- end }}
{{- else }}
{{- (index .Values.env .key) | toString | b64enc | quote }}
{{- end }}
{{- end }}

{{/*
App config secret
*/}}
{{- define "cdn-web.secretValues" -}}
{{- $secret := (lookup "v1" "Secret" .Release.Namespace (include "cdn-web.name" .)) }}
{{- range $key, $val := .Values.env }}
{{- $data := (dict "secret" $secret "Values" $.Values "key" $key) }}
{{ $key }}: {{ include "cdn-web.envValue" $data }}
{{- end }}
{{- end }}

{{/*
Registry credentials secret
*/}}
{{- define "cdn-web.imagePullSecretValue" -}}
{{- $secret := (lookup "v1" "Secret" .Release.Namespace .Values.imagePullSecretName) }}
{{- if not .Values.registryCreds }}
{{- if or (not $secret) (not $secret.data) }}
{{- required "registryCreds is required." .Values.registryCreds }}
{{- else }}
{{- index $secret.data ".dockerconfigjson" }}
{{- end }}
{{- else }}
{{- .Values.registryCreds | quote }}
{{- end }}
{{- end }}
