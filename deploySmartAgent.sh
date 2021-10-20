#!/bin/bash
if [ $# != 1 ]
then
  echo "Usage: ./deploySmartAgent.sh <token>"
  exit 1
fi

TOKEN=$1

helm repo add signalfx https://dl.signalfx.com/helm-repo
helm repo update
helm install --set signalFxAccessToken=$TOKEN --set clusterName=MyClusterSA --set agentVersion=<version> --set signalFxRealm=<realm> --generate-name signalfx/signalfx-agent