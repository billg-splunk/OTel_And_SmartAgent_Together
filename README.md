# OTel_And_SmartAgent_Together
Instructions and configurations for running the OTel Collector and Smart Agent together in Kubernetes

NOTE: This is a work in progress
## Summary of Steps
- Install Multipass & VirtualBox
- Install microk8s
- Deploy the Smart Agent
- Deploy the OTel Collector (using port 9090 instead)
- Install Docker
- Create images of simple python script calling OTel and SA
- Deploy applications

## Install Virtualbox
- Download from site and install
## Install multipass
```
brew install multipass
sudo multipass set local.driver=virtualbox
```
## Launch a vm
```
multipass launch --name microk8s --mem 8G --disk 40G
multipass shell microk8s
```
## Update OS
```
sudo apt-get update
```
## Install microk8s and open up the network
```
sudo snap install microk8s --classic --channel=1.18/stable
sudo iptables -P FORWARD ACCEPT
```
## Setup user, then exit and re-enter the session
```
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
exit
multipass shell microk8s
```
## Check microk8s is ready
```
microk8s status --wait-ready
microk8s kubectl get no
microk8s kubectl get svc
```
## OPTIONAL: Alias kubectl and un kubectl commands
```
alias k='microk8s kubectl'
```
## Install Docker
```
sudo apt-get install docker.io
```
## Add user to docker group, then exit and re-enter the session
```
sudo usermod -aG docker ${USER}
exit
multipass shell microk8s
```
## Download this repo
```
cd ~
git clone https://github.com/billg-splunk/OTel_And_SmartAgent_Together.git
```
## Install Smart Agent
```
helm repo add signalfx https://dl.signalfx.com/helm-repo
helm repo update
helm install --set signalFxAccessToken=TOKEN --set clusterName=MyCluster --set agentVersion=5.14.2 --set signalFxRealm=us1 --generate-name signalfx/signalfx-agent
```
## Install OTel Collector
```
helm repo add splunk-otel-collector-chart https://signalfx.github.io/splunk-otel-collector-chart
helm repo update
cd ~/OTel_And_SmartAgent_Together
helm install --set provider=' ' --set distro=' ' --set splunkObservability.accessToken='TOKEN' --set clusterName='MyCluster' --set splunkObservability.realm='us1' --set otelCollector.enabled='false'  --set splunkObservability.logsEnabled='false'  --generate-name splunk-otel-collector-chart/splunk-otel-collector
```

## Build the apps
The following will build the apps and deploy them to microk8s
```
cd ~/OTel_And_SmartAgent_Together/apps
source dockerbuilds.sh
```

## Deploy the apps
```
cd ~/OTel_And_SmartAgent_Together/apps
k apply -f app-otel.yaml
k apply -f app-smartagent.yaml
```

# Some other tricks for checking things
- Upgrading with helm
```
helm upgrade <same values> <collector pod> <helm chart>
```
- Checking logs
```
k logs -f <pod>
```
- Checking pods
```
k describe po <pod>
```
- Checking secrets (like the token)
```
k get secrets splunk-otel-collector -o yaml
<Find the encoded token>
echo "<token>" | base64 --decode
```
- Review configmap
```
k get cm
k edit cm <configmap>
```