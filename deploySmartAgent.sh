#!/bin/bash
if [ $# != 1 ]
then
  echo "Usage: ./deploySmartAgent.sh <token>"
  return 1 2> /dev/null || exit 1
fi

TOKEN=$1

helm repo add signalfx https://dl.signalfx.com/helm-repo
helm repo update
helm install -f values-smartagent.yaml --set signalFxAccessToken=$TOKEN --set clusterName=MyClusterSA --set agentVersion=5.14.2 --set signalFxRealm=us1 --generate-name signalfx/signalfx-agent