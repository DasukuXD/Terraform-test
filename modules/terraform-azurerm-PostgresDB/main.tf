data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                = var.postgres_server_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  version             = var.postgres_version
  tags                = var.additional_tags

  delegated_subnet_id           = var.subnet_id
  public_network_access_enabled = var.public_network_access_enabled

  administrator_login    = var.postgres_admin_login
  administrator_password = var.postgres_admin_password

  storage_mb                   = var.storage_mb
  zone                         = var.postgres_zone
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  auto_grow_enabled            = var.auto_grow_enabled

  sku_name = var.postgres_sku_name
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  for_each  = { for idx, item in var.postgres_list : item.name => item }
  name      = each.value.name
  server_id = azurerm_postgresql_flexible_server.this.id
  collation = each.value.collation
  charset   = each.value.charset
}
