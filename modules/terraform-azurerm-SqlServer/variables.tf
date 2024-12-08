# -------------------------------------- Required ------------------------------------------------
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created."
}

variable "identity_name" {
  type        = string
  description = "(Required) The name of the User Assigned Identity. Ther module will add the recommended abbreviation prefix 'id' to the actual resource name. Changing this forces a new identity to be created."
}

# -------------------------------------- Optional ------------------------------------------------

variable "additional_tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the User Assigned Identity resource."
  default     = null
}
