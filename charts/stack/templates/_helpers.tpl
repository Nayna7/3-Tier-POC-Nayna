{{/*
Expand the name of the chart.
*/}}
{{- define "stack.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create full release name
*/}}
{{- define "stack.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "stack.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Chart label
*/}}
{{- define "stack.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "stack.labels" -}}
helm.sh/chart: {{ include "stack.chart" . }}
app.kubernetes.io/name: {{ include "stack.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Service Account
*/}}
{{- define "stack.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "stack.fullname" .) .Values.serviceAccount.name }}
{{- else }}
default
{{- end }}
{{- end }}

# =========================
# BACKEND
# =========================

{{- define "stack.backend.fullname" -}}
{{- printf "%s-backend" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "stack.backend.labels" -}}
{{ include "stack.labels" . }}
app.kubernetes.io/component: backend
{{- end }}

{{- define "stack.backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "stack.name" . }}-backend
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "stack.backend.image" -}}
{{- $registry := .Values.backend.image.registry | default .Values.global.image.registry | default "docker.io" }}
{{- printf "%s/%s:%s" $registry .Values.backend.image.repository .Values.backend.image.tag }}
{{- end }}

# =========================
# FRONTEND
# =========================

{{- define "stack.frontend.fullname" -}}
{{- printf "%s-frontend" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "stack.frontend.labels" -}}
{{ include "stack.labels" . }}
app.kubernetes.io/component: frontend
{{- end }}

{{- define "stack.frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "stack.name" . }}-frontend
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "stack.frontend.image" -}}
{{- $registry := .Values.frontend.image.registry | default .Values.global.image.registry | default "docker.io" }}
{{- printf "%s/%s:%s" $registry .Values.frontend.image.repository .Values.frontend.image.tag }}
{{- end }}

# =========================
# POSTGRES
# =========================

{{/*
Postgres service name
This MUST match backend DATABASE_HOST
*/}}
{{- define "stack.postgres.fullname" -}}
{{- printf "%s-postgres" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
