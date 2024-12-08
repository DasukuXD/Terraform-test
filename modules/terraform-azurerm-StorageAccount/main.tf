data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_storage_account" "this" {
  name                     = var.st_name
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = data.azurerm_resource_group.this.location
  account_kind             = var.account_kind
  account_tier             = var.account_kind == "FileStorage" ? "Premium" : "Standard"
  account_replication_type = var.account_kind == "FileStorage" ? "LRS" : "GRS"
  access_tier              = var.access_tier
  large_file_share_enabled = var.large_file_share_enabled
  nfsv3_enabled            = var.nfsv3_enabled

  allow_nested_items_to_be_public = false
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"

  dynamic "blob_properties" {
    for_each = var.enable_soft_delete == true ? [1] : []
    content {
      delete_retention_policy {
        days = var.delete_retention
      }
      container_delete_retention_policy {
        days = var.delete_retention
      }
      versioning_enabled  = true
      change_feed_enabled = true
    }
  }

  tags = var.additional_tags
}
