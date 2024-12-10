variable "resource_group_name" {
  type        = string
  description = "(Required) Name of the resource group in which the AKS cluster will be created."
}

variable "key_vault_id" {
  type        = string
  description = "(Required) ID of the existing Key vault to store the AKS Cluster SSH admin user, SSH private key and Disk Encryption Key."
}

variable "subnet_id" {
  type        = string
  description = "(Required) ID of the existing subnet to deploy the nodes on."
}

variable "aks_name" {
  type        = string
  description = "(Required) Name of the AKS cluster."
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
    node_labels          = map(string)
    node_taints          = list(string)
  }))
  default = null
}

variable "sku_kubernetes_cluster" {
  type        = string
  description = "(Optional) The SKU which should be used for this Kubernetes Cluster. Possible values are Basic and Standard. Defaults to Standard. Changing this forces a new resource to be created."
  default     = "Standard"
}

variable "private_dns_zone_id" {
  type        = string
  description = "(Optional) The ID of the existing Log Analytics Workspace which the OMS Agent should send data to."
  default     = null
}

variable "additional_tags" {
  type        = map(string)
  description = "(Optional) Additional tags for the virtual network."
  default     = null
}

variable "user_assigned_identity_id" {
  type        = list(string)
  description = "(Optional) The ID of the User Assigned Identity assigned to the Kubelets. If not specified a Managed Identity is created automatically. Changing this forces a new resource to be created."
}

variable "kubelet_identity" {
  type = object({
    client_id                 = string
    object_id                 = string
    user_assigned_identity_id = string
  })
  default = null
}

variable "service_mesh_profile" {
  type = object({
    mode                             = string
    internal_ingress_gateway_enabled = optional(bool, true)
    external_ingress_gateway_enabled = optional(bool, true)
    revisions                        = string
  })
  default = null
}

variable "workload_autoscaler_profile" {
  type = object({
    keda_enabled                    = optional(bool, false)
    vertical_pod_autoscaler_enabled = optional(bool, false)
  })
  default = null
}
