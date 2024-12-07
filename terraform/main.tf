resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

module "virtual_network" {
  source = "../modules/terraform-azurerm-VirtualNetwork"

  vnet_name           = var.vnet_name
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.address_space
  subnets             = var.subnets

  depends_on = [azurerm_resource_group.this]
}

module "managed_identity_storage_account" {
  source = "../modules/terraform-azurerm-UserAssignIdentity"

  resource_group_name = azurerm_resource_group.this.name
  identity_name       = var.identity_name

  depends_on = [azurerm_resource_group.this]
}

module "storage_account_role_assignment" {
  source = "../modules/terraform-azurerm-RoleAssignment"

  scope                = azurerm_storage_account.this.id
  principal_id         = module.managed_identity_storage_account.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  description          = "Role Assignment to allow blobs to be created in the storage account"

  depends_on = [module.managed_identity_storage_account]
}
