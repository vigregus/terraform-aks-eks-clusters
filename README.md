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




 az vm list-skus --location westus2 --size Standard_D --all --output table| grep None
 Standard_D4ps_v5 



https://github.com/Azure/application-gateway-kubernetes-ingress/issues/1533

https://learn.microsoft.com/en-us/azure/application-gateway/for-containers/quickstart-deploy-application-gateway-for-containers-alb-controller?tabs=install-helm-windows

  1 az aks update -g myResourceGroup  -n myAKSCluster  --enable-oidc-issuer --enable-workload-identity
2 az identity create --name manageidname --resource-group myResourceGroup --location westus2
        {
    "clientId": "d7f894e3-ec2b-4fe9-9c6a-fbc9e8c9a31b",
    "id": "/subscriptions/c59cf824-2a78-42de-92c6-c0d6a5f25cb1/resourcegroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/manageidname",
    "location": "westus2",
    "name": "manageidname",
    "principalId": "696e5cb6-ad3e-4212-90fc-585291f65745",
    "resourceGroup": "myResourceGroup",
    "systemData": null,
    "tags": {},
    "tenantId": "3822b983-0881-4731-b451-98a08094837e",
    "type": "Microsoft.ManagedIdentity/userAssignedIdentities"
    }
az identity show -g myResourceGroup -n manageidname

