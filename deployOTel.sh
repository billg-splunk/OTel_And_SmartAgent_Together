#!/bin/bash
if [ $# != 1 ]
then
  echo "Usage: ./deployOTel.sh <token>"
  exit
fi

TOKEN=$1

helm repo add splunk-otel-collector-chart https://signalfx.github.io/splunk-otel-collector-chart
helm repo update
helm install -f values-otel.yaml --set provider=' ' --set distro=' ' --set splunkObservability.accessToken='$TOKEN' --set clusterName='MyClusterOTel' --set splunkObservability.realm='us1' --set otelCollector.enabled='false'  --set splunkObservability.logsEnabled='false'  --generate-name splunk-otel-collector-chart/splunk-otel-collector