resource "azurerm_user_assigned_identity" "testIdentity" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "${var.prefix}-identity1"
  tags = {
    env = "${var.prefix}"
  }
}

resource "azurerm_application_gateway" "appgw" {
  depends_on = [ azurerm_public_ip.pip ]
  name                = "${var.prefix}-app-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "${var.prefix}-gateway-ip-config"
    subnet_id = azurerm_subnet.appgwsubnet.id
  }

  frontend_ip_configuration {
    name                 = "${var.prefix}-frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  frontend_port {
    name = "${var.prefix}-frontend-port"
    port = 80
  }

  backend_address_pool {
    name = "${var.prefix}-backend-address-pool"
  }

  probe {
    name                = "${var.prefix}-probe"
    protocol            = "Http"
    host                = "127.0.0.1"
    port                = 80
    path                = "/"
    interval            = 30
    timeout             = 20
    unhealthy_threshold = 3
  }

  backend_http_settings {
    name                  = "${var.prefix}-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
    probe_name            = "${var.prefix}-probe"
  }

  http_listener {
    name                           = "${var.prefix}-http-listener"
    frontend_ip_configuration_name = "${var.prefix}-frontend-ip-config"
    frontend_port_name             = "${var.prefix}-frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${var.prefix}-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "${var.prefix}-http-listener"
    backend_address_pool_name  = "${var.prefix}-backend-address-pool"
    backend_http_settings_name = "${var.prefix}-http-settings"
    priority                   = 100
  }

  lifecycle {
    ignore_changes = [
      tags,
      backend_address_pool,
      backend_http_settings,
      frontend_port,
      http_listener,
      probe,
      redirect_configuration,
      request_routing_rule,
      ssl_certificate
    ]
  }

  tags = {
    env = "${var.prefix}"
  }
}

data "azurerm_resources" "vnet" {
  type                = "Microsoft.Network/virtualNetworks"
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
}



resource "azurerm_role_assignment" "aks_appgw_role" {
  principal_id         = azurerm_user_assigned_identity.testIdentity.principal_id
  role_definition_name = "Contributor"
  scope                = azurerm_application_gateway.appgw.id
}

resource "azurerm_role_assignment" "ra1" {
  scope                = azurerm_virtual_network.vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.testIdentity.principal_id
  depends_on = [azurerm_virtual_network.vnet]
}

resource "azurerm_role_assignment" "ra3" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.testIdentity.principal_id
}
resource "azurerm_federated_identity_credential" "example" {
  depends_on = [azurerm_user_assigned_identity.testIdentity]
  name                = "${var.prefix}-federated-identity"
  resource_group_name = azurerm_resource_group.rg.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.testIdentity.id
  subject             = "system:serviceaccount:default:ingress-azure"
}