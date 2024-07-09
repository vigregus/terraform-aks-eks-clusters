provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-resource-group"
  location = "westus2"
  tags = {
    env = "${var.prefix}"
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.prefix}-aks"
  oidc_issuer_enabled = true
  workload_identity_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D4ps_v5"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    dns_service_ip    = "10.0.1.10"
    service_cidr      = azurerm_subnet.akssubnet.address_prefixes[0]
  }
  tags = {
    env = "${var.prefix}"
  }
}


provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }
}



resource "helm_release" "appgw_ingress" {
  depends_on = [azurerm_federated_identity_credential.example, azurerm_kubernetes_cluster.aks]
  name       = "ingress-azure"
  repository = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
  chart      = "ingress-azure"
  timeout    = 125
  create_namespace = true
  namespace = "default"

  values = [
    <<-EOF
verbosityLevel: 5
appgw:
  subscriptionId: c59cf824-2a78-42de-92c6-c0d6a5f25cb1
  resourceGroup: "${azurerm_resource_group.rg.name}"
  name: "${azurerm_application_gateway.appgw.name}"
  shared: false
armAuth:
  type: workloadIdentity
  identityClientID: "${azurerm_user_assigned_identity.testIdentity.client_id}"
rbac:
  enabled: true
aksClusterConfiguration:
  apiServerAddress: "${azurerm_kubernetes_cluster.aks.kube_config[0].host}" 
EOF
  ]
}

