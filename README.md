# Kinvolk service mesh benchmark suite

This is v2.0 release of our benchmark automation suite.

Please refer to the [1.0 release](tree/release-1.0) for automation discussed in our [2019 blog post](https://kinvolk.io/blog/2019/05/kubernetes-service-mesh-benchmarking/).

# Content

The suite includes:
- orchestrator [tooling](orchestrator) and [Helm charts](configs/orchestrator)
    for deploying benchmark clusters from an orchestrator cluster
    - metrics of all benchmark clusters will be scraped and made available in
      the orchestrator cluster
- a stand-alone benchmark cluster [configuration](configs/equinix-metal-cluster.lokocfg)
    for use with [Lokomotive](https://github.com/kinvolk/lokomotive/releases/)
- helm charts for deploying [Emojivoto](configs/emojivoto)
    to provide application endpoints to run benchmarks against
- helm charts for deploying a [wrk2 benchmark job](configs/benchmark) as well
  as a job to create
    [summary metrics of multiple benchmark runs](configs/metrics-merger)
- Grafana [dashboards](dashboards/) to view benchmark metrics

## Run a benchmark suit

0. install helm
```shell
# To see more: https://helm.sh/docs/intro/install/
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# with proxy
curl -x 127.0.0.1:7890 https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update -o Acquire::http::proxy="http://127.0.0.1:7890/"
sudo apt-get install helm -o Acquire::http::proxy="http://127.0.0.1:7890/"
```

1. install kube-prometheus and pushgateway
```shell
# install kube-prometheus operator
git clone https://github.com/prometheus-operator/kube-prometheus
cd kube-prometheus
kubectl apply --server-side -f manifests/setup
kubectl wait --for condition=Established --all CustomResourceDefinition --namespace=monitoring
kubectl apply -f manifests/
# deploy prometheus push gateway
helm install pushgateway --namespace monitoring configs/pushgateway
```

2. upload grafana configration
```shell
# forward port to view grafana in browser
kubectl port-forward -n monitoring svc/grafana 3000:3000 &
# generte API key
# upload configration
cd dashboards
./upload_dashboard.sh "[API KEY]" grafana-wrk2-cockpit.json localhost:3000
# add data source: Data Sources/Prometheus Name:Prometheus URL:http://prometheus-k8s.monitoring:9090
```

3. start the benchmark
```shell
# see scripts/run_benchmarks.sh 
./scripts/run_benchmarks.sh
```
