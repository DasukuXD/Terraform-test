output "fqdn" {
  value       = azurerm_postgresql_flexible_server.this.fqdn
  description = "Name of the Postgres flexible server"
}

output "postgres_admin_login" {
  value       = azurerm_postgresql_flexible_server.this.administrator_login
  description = "User id to login Postgres flexible server"
}

output "postgres_admin_password" {
  value       = azurerm_postgresql_flexible_server.this.administrator_login_password
  description = "Password to login Postgres flexible server"
}

output "postgres_server_name" {
  value       = azurerm_postgresql_flexible_server.this.name
  description = "Name of the Postgres flexible server"
}

output "postgres_server_ids" {
  value       = azurerm_postgresql_flexible_server.this.id
  description = "Postgres flexible server ids"
}
