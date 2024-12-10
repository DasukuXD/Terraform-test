output "name" {
  description = "value of the name of the identity."
  value       = azurerm_user_assigned_identity.this.name
}

output "id" {
  description = "value of the id of the identity."
  value       = azurerm_user_assigned_identity.this.id
}

output "principal_id" {
  description = "value of the principal id of the identity."
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "client_id" {
  description = "value of the client id of the identity."
  value       = azurerm_user_assigned_identity.this.client_id
}

output "tenant_id" {
  description = "value of the tenant id of the identity."
  value       = azurerm_user_assigned_identity.this.tenant_id
}
