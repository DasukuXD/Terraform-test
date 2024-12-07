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
}
