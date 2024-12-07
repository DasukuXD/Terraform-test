data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.this.name
  address_space       = var.address_space
  dns_servers         = var.dns_servers

  tags = var.additional_tags
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                                          = each.key
  resource_group_name                           = data.azurerm_resource_group.this.name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = each.value["address_prefixes"]
  service_endpoints                             = lookup(each.value, "service_endpoints", null)
  private_link_service_network_policies_enabled = lookup(each.value, "pl_enable", null)

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", [])

    content {
      name = lookup(delegation.value, "name", null)
      dynamic "service_delegation" {
        for_each = lookup(delegation.value, "service_delegation", [])
        content {
          name    = lookup(service_delegation.value, "name", null)
          actions = lookup(service_delegation.value, "actions", null)
        }
      }
    }
  }

  depends_on = [azurerm_virtual_network.this]
}
