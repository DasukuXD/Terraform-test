output "name" {
  value       = azurerm_storage_account.this.name
  description = "Name of the storage account"
}

output "id" {
  value       = azurerm_storage_account.this.id
  description = "ID of the storage account"
}

output "primary_connection_string" {
  value       = azurerm_storage_account.this.primary_connection_string
  description = "The primary connection string for the storage account"
}
