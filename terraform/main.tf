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

module "storage_account" {
  source = "../modules/terraform-azurerm-StorageAccount"

  st_name             = var.st_name
  resource_group_name = azurerm_resource_group.this.name
}

module "private_endpoints" {
  source = "../modules/terraform-azurerm-PrivateEndpoint"

  resource_group_name = azurerm_resource_group.this.name
  private_endpoints = {
    pe_vm = {
      name                           = "pe-vm"
      subnet_id                      = module.virtual_network.map_subnet_ids["subnet-vm"]
      group_ids                      = []
      approval_required              = var.approval_required
      approval_message               = "Please approve Private Endpoint connection pe_vm"
      private_connection_resource_id = azurerm_virtual_machine.this.id
    },
    pe_sa = {
      name                           = "pe-sa"
      subnet_id                      = module.virtual_network.map_subnet_ids["subnet-sa"]
      group_ids                      = ["blob"]
      approval_required              = var.approval_required
      approval_message               = "Please approve Private Endpoint connection pe_sa"
      private_connection_resource_id = module.storage_account.id
    }
  }
  depends_on = [azurerm_resource_group.this, module.virtual_network, azurerm_virtual_machine.this, module.storage_account]
}

module "managed_identity_storage_account" {
  source = "../modules/terraform-azurerm-UserAssignIdentity"

  resource_group_name = azurerm_resource_group.this.name
  identity_name       = var.identity_name

  depends_on = [azurerm_resource_group.this]
}

module "storage_account_role_assignment" {
  source = "../modules/terraform-azurerm-RoleAssignment"

  scope                = module.storage_account.id
  principal_id         = module.managed_identity_storage_account.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  description          = "Role Assignment to allow blobs to be created in the storage account"

  depends_on = [module.managed_identity_storage_account]
}

module "aks_cluster" {
  source = "../modules/terraform-azurerm-Aks"

  resource_group_name           = azurerm_resource_group.this.name
  aks_name                      = var.aks_name
  subnet_id                     = module.virtual_network.map_subnet_ids["subnet-vm"]
  user_assigned_identity_id     = [module.managed_identity_storage_account.id]
  key_vault_id                  = azurerm_key_vault.this.id
  aks_cluster                   = var.aks_cluster
  aks_cluster_worker_node_pools = var.aks_cluster_worker_node_pools

  service_mesh_profile = {
    mode                             = "Istio"
    internal_ingress_gateway_enabled = true
    external_ingress_gateway_enabled = true
    revisions                        = "asm-1-20"
  }

  workload_autoscaler_profile = {
    keda_enabled                    = true
    vertical_pod_autoscaler_enabled = true
  }

  depends_on = [azurerm_resource_group.this, module.virtual_network, module.managed_identity_storage_account, azurerm_key_vault.this]
}
