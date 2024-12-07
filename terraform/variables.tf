variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "Southeast Asia"
}

# =========================================================================
# ---------------------------- Virtual network ----------------------------
# =========================================================================

variable "vnet_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "subnets" {
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
}

# =========================================================================
# ---------------------------- Managed Identity ---------------------------
# =========================================================================

variable "identity_name" {
  type = string
}

# =========================================================================
# --------------------------- Private Endpoint ----------------------------
# =========================================================================

variable "approval_required" {
  type = bool
}
