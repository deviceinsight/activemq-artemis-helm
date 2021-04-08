{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "artemis.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "artemis.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a secret name based on the configuration, if it is auto-generated or preexisting
*/}}
{{- define "artemis.secretname" -}}
{{- if .Values.auth.existingSecret -}}
{{- .Values.auth.existingSecret -}}
{{- else -}}
{{- include "artemis.fullname" . }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "artemis.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "artemis.labels" -}}
app.kubernetes.io/name: {{ include "artemis.name" . }}
helm.sh/chart: {{ include "artemis.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}


{{- define "artemis.labels.live" -}}
{{ include "artemis.labels" . }}
{{- if .Values.ha.enabled }}
app.kubernetes.io/ha: live
{{- end }}
{{- end -}}

{{- define "artemis.labels.backup" -}}
{{ include "artemis.labels" . }}
app.kubernetes.io/ha: backup
{{- end -}}

{{- define "artemis.statefulset.spec" -}}
initContainers:
- name: copy-broker-config
  image: {{ .Values.initContainerImage.repository }}:{{ .Values.initContainerImage.tag }}
  imagePullPolicy: {{ .Values.initContainerImage.pullPolicy}}
  command:
    - bash
  args:
    - -c
    - cp /tmp/config/*.{xml,xslt} /tmp/etc-override/
  volumeMounts:
  - name: config
    mountPath: /tmp/config
  - name: etc-override
    mountPath: /tmp/etc-override
- name: set-pod-ip
  image: {{ .Values.initContainerImage.repository }}:{{ .Values.initContainerImage.tag }}
  imagePullPolicy: {{ .Values.initContainerImage.pullPolicy}}
  command:
    - bash
  args:
    - -c
    - sed -i 's/$EXTERNAL_IP/'"$POD_IP"'/' /tmp/etc-override/connectors.xml
  env:
  - name: POD_IP
    valueFrom:
      fieldRef:
        fieldPath: status.podIP
  volumeMounts:
  - name: etc-override
    mountPath: /tmp/etc-override
- name: set-users
  image: {{ .Values.initContainerImage.repository }}:{{ .Values.initContainerImage.tag }}
  imagePullPolicy: {{ .Values.initContainerImage.pullPolicy}}
  env:
    {{- range $user, $properties := .Values.users }}
    - name: ARTEMIS_USER_PW_{{ $user | upper | replace "-" "_" }}
      valueFrom:
        secretKeyRef:
          name: {{ $properties.secretName  }}
          key: {{ $properties.secretKey }}
    {{- end }}
  command:
    - sh
    - "-c"
    - |
      bash <<'EOF'
      touch /tmp/artemis/artemis-users.properties /tmp/artemis/artemis-roles.properties
      {{- range $user, $properties := .Values.users }}
      echo "{{ $properties.user }} = $ARTEMIS_USER_PW_{{ $user | upper | replace "-" "_" }}" >> /tmp/artemis/artemis-users.properties
      {{- end }}
      {{- range $roleBinding := .Values.roleBindings }}
      echo "{{ $roleBinding.role }} = {{ join "," $roleBinding.users }}" >> /tmp/artemis/artemis-roles.properties
      {{- end }}
      echo "Created config files"
      echo "Set config file owner to 1000:1000 (artemis:artemis)..."
      chown -R 1000:1000 /tmp/artemis
      EOF
  volumeMounts:
  - name: artemis-users
    mountPath: /tmp/artemis
containers:
- name: activemq-artemis
  image: {{ required "image repository is required" .Values.image.repository }}:{{ required "image tag is required" .Values.image.tag }}
  imagePullPolicy: {{ .Values.image.pullPolicy}}
  resources:
    {{- toYaml .Values.resources | nindent 4 }}
  ports:
  - containerPort: 61616
    name: netty
  - containerPort: 5672
    name: amqp
  - containerPort: 61613
    name: stomp
  - containerPort: 1883
    name: mqtt
  - containerPort: 7800
    name: jgroups
  - containerPort: 8888
    name: kubeping
  - containerPort: 8161
    name: http
  {{- if .Values.metrics.enabled }}
  - containerPort: 9404
    name: prometheus
  {{- end }}
  readinessProbe:
  {{- if .Values.readinessProbe }}
    {{- toYaml .Values.readinessProbe | nindent 4 }}
  {{- end }}
  {{- if .Values.livenessProbe }}
  livenessProbe:
    {{- toYaml .Values.livenessProbe | nindent 4 }}
  {{- end }}
  env:
    - name: JAVA_OPTS
      value: "{{ .Values.javaOpts }}"
    - name: ARTEMIS_USERNAME
      value: {{ .Values.auth.clientUser }}
    - name: ARTEMIS_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "artemis.secretname" . }}
          key: clientPassword
    - name: BROKER_CONFIG_CLUSTER_PASSWORD
      valueFrom:
        secretKeyRef:
            name: {{ include "artemis.secretname" . }}
            key: clusterPassword
    - name: ENABLE_JMX_EXPORTER
      value: {{ .Values.metrics.enabled | quote }}
  {{- if .Values.containerSecurityContext }}
  securityContext:
    {{- toYaml .Values.containerSecurityContext | nindent 10 }}
  {{- end }}
  volumeMounts:
  - name: data
    mountPath: /var/lib/artemis/data
  - name: etc-override
    mountPath: /var/lib/artemis/etc-override
  - name: jgroups
    mountPath: /var/lib/artemis/etc/jgroups
  - name: artemis-users
    mountPath: /var/lib/artemis/etc/artemis-users.properties
    subPath: artemis-users.properties
  - name: artemis-users
    mountPath: /var/lib/artemis/etc/artemis-roles.properties
    subPath: artemis-roles.properties
serviceAccount: {{ include "artemis.fullname" . }}
{{- if .Values.podSecurityContext }}
securityContext:
  {{- toYaml .Values.podSecurityContext | nindent 8 }}
{{- end }}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.image.pullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
volumes:
- name: etc-override
  emptyDir: {}
- name: artemis-users
  emptyDir: {}
- name: jgroups
  configMap:
    name: {{ include "artemis.fullname" . }}
    items:
    - key: jgroups-discovery.xml
      path: jgroups-discovery.xml
{{- if not .Values.persistence.enabled }}
- name: data
  emptyDir: {}
{{- end }}
- name: config
  configMap:
    name: {{ include "artemis.fullname" . }}
    items:
    - key: addresses.xml
      path: addresses.xml
    - key: address-settings.xml
      path: address-settings.xml
    - key: broadcast.xml
      path: broadcast.xml
    - key: clustering.xml
      path: clustering.xml
    - key: connectors.xml
      path: connectors.xml
    - key: discovery.xml
      path: discovery.xml
    - key: broker-00.xslt
      path: broker-00.xslt
{{- end -}}

{{- define "artemis.statefulset.volumeclaim" -}}
{{- if .Values.persistence.enabled }}
volumeClaimTemplates:
- metadata:
    name: data
  spec:
    accessModes:
{{ toYaml .Values.persistence.accessModes | indent 6 }}
    {{- if .Values.persistence.storageClassName }}
    storageClassName: {{ .Values.persistence.storageClassName }}
    {{- end }}
    resources:
      requests:
        storage: {{ .Values.persistence.storageSize }}
  {{- end }}
{{- end -}}
