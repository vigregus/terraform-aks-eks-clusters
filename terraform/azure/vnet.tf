resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    env = "${var.prefix}"
  }
}
resource "azurerm_public_ip" "pip" {
  depends_on = [ azurerm_resource_group.rg ]
  name                = "${var.prefix}-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    env = "${var.prefix}"
  }
}

resource "azurerm_subnet" "akssubnet" {
  depends_on = [ azurerm_virtual_network.vnet ] 
  name                 = "${var.prefix}-aks-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "appgwsubnet" {
  depends_on = [ azurerm_virtual_network.vnet ] 
  name                 = "${var.prefix}-appgw-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  
}



resource "azurerm_virtual_network_peering" "aks_to_appgw" {
  depends_on = [azurerm_application_gateway.appgw]
  name                      = "${var.prefix}-aks-to-appgw"
  resource_group_name       = azurerm_kubernetes_cluster.aks.node_resource_group
  virtual_network_name      = data.azurerm_resources.vnet.resources[0].name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
}

resource "azurerm_virtual_network_peering" "appgw_to_aks" {
  depends_on = [azurerm_application_gateway.appgw]
  name                      = "${var.prefix}-appgw-to-aks"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = data.azurerm_resources.vnet.resources[0].id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
}


