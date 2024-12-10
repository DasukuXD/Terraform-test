data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_private_endpoint" "this" {
  for_each = var.private_endpoints

  name                = each.value["name"]
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  subnet_id           = each.value["subnet_id"]

  private_service_connection {
    name                           = "${each.value["name"]}-connection"
    is_manual_connection           = coalesce(lookup(each.value, "approval_required"), false)
    private_connection_resource_id = each.value["private_connection_resource_id"]
    subresource_names              = lookup(each.value, "group_ids ", null)
    request_message = coalesce(
    lookup(each.value, "approval_required"), false) == true ? coalesce(lookup(each.value, "approval_required"), var.default_request_message) : null
  }

  tags = var.additional_tags
}
