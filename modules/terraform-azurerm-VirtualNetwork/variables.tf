# -------------------------------------- Required ------------------------------------------------

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created."
}

variable "vnet_name" {
  type        = string
  description = "(Required) The name of the virtual network. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "Southeast Asia"
}

variable "address_space" {
  type        = list(string)
  description = "(Required) The address space that is used the virtual network. You can supply more than one address space."
}

# -------------------------------------- Optional ------------------------------------------------

variable "dns_servers" {
  type        = list(string)
  description = "(Optional) List of IP addresses of DNS servers"
  default     = []
}

variable "additional_tags" {
  type        = map(string)
  description = "(Optional) Additional tags for the virtual network."
  default     = null
}

variable "subnets" {
  description = "(Optional) Can be specified multiple times to define multiple subnets. Each subnet block supports fields documented below."
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = list(string)
    pl_enable         = optional(bool)
    delegation = list(object({
      name = string
      service_delegation = list(object({
        name    = string
        actions = list(string)
      }))
    }))
  }))
  default = {}
}

