# -------------------------------------- Required ------------------------------------------------
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created."
}

variable "postgres_server_name" {
  type        = string
  description = "(Required) The name which should be used for this PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created."
}

# -------------------------------------- Optional ------------------------------------------------

variable "postgres_admin_login" {
  type        = string
  description = "(Optional) The Administrator login for the PostgreSQL Flexible Server. Required when create_mode is Default and authentication.password_auth_enabled is true."
}

variable "postgres_admin_password" {
  type        = string
  description = "(Optional) The Password associated with the administrator_login for the PostgreSQL Flexible Server. Required when create_mode is Default and authentication.password_auth_enabled is true."
}

variable "storage_mb" {
  type        = number
  description = "(Optional) The max storage allowed for the PostgreSQL Flexible Server. Possible values are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4193280, 4194304, 8388608, 16777216 and 33553408."
}

variable "postgres_zone" {
  type        = string
  description = " (Optional) Specifies the Availability Zone in which the PostgreSQL Flexible Server should be located."
}

variable "backup_retention_days" {
  type        = number
  description = "(Optional) The backup retention days for the PostgreSQL Flexible Server. Possible values are between 7 and 35 days."
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "(Optional) Is Geo-Redundant backup enabled on the PostgreSQL Flexible Server. Defaults to false. Changing this forces a new PostgreSQL Flexible Server to be created."
  default     = false
}

variable "auto_grow_enabled" {
  type        = bool
  description = "(Optional) Is the storage auto grow for PostgreSQL Flexible Server enabled? Defaults to false."
  default     = false
}

variable "postgres_sku_name" {
  type        = string
  description = "(Optional) The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the tier + name pattern (e.g. B_Standard_B1ms, GP_Standard_D2s_v3, MO_Standard_E4s_v3)."
}

variable "postgres_version" {
  type        = string
  description = "(Optional) The version of PostgreSQL Flexible Server to use. Possible values are 11,12, 13, 14, 15 and 16. Required when create_mode is Default."
  default     = "12"
}

variable "subnet_id" {
  type        = string
  description = "(Optional) The ID of the virtual network subnet to create the PostgreSQL Flexible Server. The provided subnet should not have any other resource deployed in it and this subnet will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created."
}

variable "public_network_access_enabled" {
  type        = bool
  description = "(Optional) Specifies whether this PostgreSQL Flexible Server is publicly accessible. Defaults to true."
  default     = false
}

variable "postgres_list" {
  type = list(object({
    name        = string
    collation   = string
    charset     = string
    create_role = bool
  }))
  default = []
}

variable "additional_tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the User Assigned Identity resource."
  default     = null
}
