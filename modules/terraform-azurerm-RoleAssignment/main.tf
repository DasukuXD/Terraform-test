resource "azurerm_role_assignment" "this" {
  principal_id         = var.principal_id
  scope                = var.scope
  role_definition_id   = var.role_definition_id
  role_definition_name = var.role_definition_name

  name                                   = var.name
  description                            = var.description
  skip_service_principal_aad_check       = var.skip_service_principal_aad_check
  delegated_managed_identity_resource_id = var.delegated_managed_identity_resource_id
  condition                              = var.condition
  condition_version                      = var.condition_version
}
