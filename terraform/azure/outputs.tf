output "role_assignment_id" {
  value = azurerm_role_assignment.aks_appgw_role.id
}
output "appgw_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}
