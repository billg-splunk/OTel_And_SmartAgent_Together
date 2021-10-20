# Build the apps
sudo docker build . -f app-otel.dockerfile -t app-otel
sudo docker build . -f app-smartagent.dockerfile -t app-sa

# Push them to microk8s and then cleanup intermediate files
docker save app-otel > app-otel.tar
docker save app-sa > app-sa.tar
microk8s ctr image import app-otel.tar
microk8s ctr image import app-sa.tar
rm app-otel.tar
rm app-sa.tar


helm upgrade -f values-otel-harnit.yaml --set provider=' ' --set distro=' ' --set splunkObservability.accessToken=‘ijZdEC_FU3lEhJdUiV330g’ --set clusterName='MyCluster' --set splunkObservability.realm='us1' --set otelCollector.enabled='false'  --set splunkObservability.logsEnabled='false' splunk-otel-collector-1633729006 splunk-otel-collector-chart/splunk-otel-collector

helm upgrade -f values-otel-harnit.yaml --set provider=' ' --set distro=' ' --set splunkObservability.accessToken='ijZdEC_FU3lEhJdUiV330g' --set clusterName='MyCluster' --set splunkObservability.realm='us1' --set otelCollector.enabled='false'  --set splunkObservability.logsEnabled='false' splunk-otel-collector-1633729006 splunk-otel-collector-chart/splunk-otel-collector