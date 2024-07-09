For Azure Cloud:
 terraform  -chdir=terraform/azure init
 terraform  -chdir=terraform/azure plan -var-file=../../dev.tfvars -out=azure-plan
 terraform  -chdir=terraform/azure apply azure-plan
 az aks get-credentials --resource-group test-mind-io-resource-group --name test-mind-io-aks-cluster --overwrite-existing

 k get ingress -nexample
 curl -H "Host: app.vigregus.com" http://52.183.97.150
 terraform  -chdir=terraform/azure destroy

For AWS Cloud:
 terraform  -chdir=terraform/aws init 
 terraform  -chdir=terraform/aws  plan -var-file=../../dev.tfvars -out=aws-plan
 terraform  -chdir=terraform/aws  apply aws-plan
 aws eks update-kubeconfig --region eu-west-1 --name test-mind-io-eks-cluster
 k get ingress -nexample
 curl -H "Host: app.vigregus.com" http://k8s-example3common-a2eb0d7220-593946512.eu-west-1.elb.amazonaws.com
 terraform  -chdir=terraform/aws  destroy




