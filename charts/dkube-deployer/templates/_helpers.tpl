{{/*
Expand the name of the chart.
*/}}
{{- define "dkube-deployer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dkube-deployer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dkube-deployer.labels" -}}
helm.sh/chart: {{ include "dkube-deployer.chart" . }}
{{ include "dkube-deployer.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.version | quote }}
app.kubernetes.io/managed-by: "dkube.io"
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dkube-deployer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dkube-deployer.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
DockerRegistry
*/}}
{{- define "dkube-deployer.dockerRegistryName" -}}
{{- with .Values }}
{{- if and ( eq .airgap "yes" ) ( eq .registry.name "docker.io/ocdr" ) }}
{{- printf "%s" "registry-server.dkube.io:443/docker.io/ocdr" }}
{{- else }}
{{- printf "%s" .registry.name }}
{{- end }}
{{- end }}
{{- end }}

{{- define "dkube-deployer.dockerRegistryUser" -}}
{{- if .Values.registry.username }}
{{- printf "%s" .Values.registry.username }}
{{- else if ( eq ( include "dkube-deployer.dockerRegistryName" . ) "registry-server.dkube.io:443/docker.io/ocdr" ) }}
{{- printf "admin" }}
{{- else }}
{{ required "Registry username is required in values.yaml" .Values.registry.username }}
{{- end }}
{{- end }}

{{- define "dkube-deployer.dockerRegistryPass" -}}
{{- if .Values.registry.password }}
{{- printf "%s" .Values.registry.password }}
{{- else if ( eq ( include "dkube-deployer.dockerRegistryName" . ) "registry-server.dkube.io:443/docker.io/ocdr" ) }}
{{- printf "bitnami" }}
{{- else }}
{{ required "Registry password is required in values.yaml" .Values.registry.password }}
{{- end }}
{{- end }}

{{/*
CICDDockerRegistry
*/}}
{{- define "dkube-deployer.CICDdockerRegistryName" -}}
{{- with .Values }}
{{- if and ( eq .airgap "yes" ) ( eq .optional.CICD.registryName "docker.io/ocdr" ) }}
{{- printf "registry-server.dkube.io:443/docker.io/ocdr" }}
{{- else }}
{{- printf "%s" .optional.CICD.registryName }}
{{- end }}
{{- end }}
{{- end }}

{{- define "dkube-deployer.CICDdockerRegistryUser" -}}
{{- if .Values.optional.CICD.registryUsername }}
{{- printf "%s" .Values.optional.CICD.registryUsername }}
{{- else if ( eq ( include "dkube-deployer.CICDdockerRegistryName" . ) "registry-server.dkube.io:443/docker.io/ocdr" ) }}
{{- printf "admin" }}
{{- else if ( and ( eq .Values.optional.CICD.enabled "true" ) ( not .Values.provider "eks") ) }}
{{ required "CICD registry username is required in values.yaml" .Values.optional.CICD.registryUsername }}
{{- end }}
{{- end }}

{{- define "dkube-deployer.CICDdockerRegistryPass" -}}
{{- if .Values.optional.CICD.registryPassword }}
{{- printf "%s" .Values.optional.CICD.registryPassword }}
{{- else if ( eq ( include "dkube-deployer.CICDdockerRegistryName" . ) "registry-server.dkube.io:443/docker.io/ocdr" ) }}
{{- printf "bitnami" }}
{{- else if ( and ( eq .Values.optional.CICD.enabled "true" ) ( not .Values.provider "eks") ) }}
{{ required "CICD registry password is required in values.yaml" .Values.optional.CICD.registryPassword }}
{{- end }}
{{- end }}

{{/*
Image pull secret
*/}}
{{- define "dkube-deployer.imagePullSecretData" -}}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"ocdlgit@oneconvergence.com\",\"auth\":\"%s\"}}}" ( include "dkube-deployer.dockerRegistryName" . ) ( include "dkube-deployer.dockerRegistryUser" . ) ( include "dkube-deployer.dockerRegistryPass" . ) (printf "%s:%s" ( include "dkube-deployer.dockerRegistryUser" . ) ( include "dkube-deployer.dockerRegistryPass" . ) | b64enc) | b64enc }}
{{- end }}


{{/*
model catalog enable flag
*/}}
{{- define "dkube-deployer.modelCatalog" -}}
{{- if hasPrefix "2.1" .Values.version }}
{{- printf "false" }}
{{- else }}
{{- printf "true" }}
{{- end }}
{{- end }}
