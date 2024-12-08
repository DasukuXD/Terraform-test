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

# =========================================================================
# -------------------------- Kubernetes Cluster ---------------------------
# =========================================================================

variable "aks_name" {
  type        = string
  description = "Name of the AKS cluster"
}

variable "aks_cluster" {
  type = object({
    kubernetes_version        = string
    node_resource_group       = string
    private_dns_zone_id       = string
    dns_prefix                = string
    automatic_upgrade_channel = string
    open_service_mesh_enabled = bool
    oidc_issuer_enabled       = bool
    workload_identity_enabled = bool

    default_node_pool = object({
      name                 = string
      vm_size              = string
      orchestrator_version = string
      max_pods             = number
      node_labels          = map(string)
      os_disk_type         = string
      os_disk_size_gb      = number
      os_sku               = string
      availability_zones   = list(string)
      max_count            = number
      min_count            = number
      node_count           = number
    })
  })
}

variable "aks_cluster_worker_node_pools" {
  type = map(object({
    name                 = string
    vm_size              = string
    orchestrator_version = string
    max_pods             = number
    node_labels          = map(string)
    os_disk_type         = string
    os_disk_size_gb      = number
    os_sku               = string
    availability_zones   = list(string)
    max_count            = number
    min_count            = number
    subnet_id            = string
    node_count           = number
    node_taints          = list(string)
  }))
}
