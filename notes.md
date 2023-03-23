## get-creds and connect to both clusters
az aks get-credentials --resource-group rg-loadtesting-demo --name aks-alt-demo2
az aks get-credentials --resource-group rg-loadtesting-demo --name aks-alt-demo-beefy

## deploy nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/cloud/deploy.yaml

## deploy test workload (pick the right folder)
kubectl apply -f .\k8s\altdemo\beefy\
kubectl apply -f .\k8s\altdemo\small\

## deploy prometheus & grafana
kubectl create -f .\k8s\kube-prometheus\manifests\setup\
kubectl apply -f .\k8s\kube-prometheus\manifests\

## set context 
kubectl config set-context --current --namespace=altdemo

## launch grafana dashboard
kubectl port-forward -n monitoring svc/grafana 3000:3000

## scale up
kubectl scale --replicas=10 deployment altdemo -n altdemo

## URLs
http://azure-load-testing-demo.westeurope.cloudapp.azure.com
http://azure-load-testing-demo-beefy.westeurope.cloudapp.azure.com