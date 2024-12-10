data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_key_vault" "this" {
  resource_group_name = split("/", var.key_vault_id)[4]
  name                = split("/", var.key_vault_id)[8]
}

data "azurerm_subnet" "this" {
  name                 = split("/", var.subnet_id)[10]
  virtual_network_name = split("/", var.subnet_id)[8]
  resource_group_name  = split("/", var.subnet_id)[4]
}

resource "random_pet" "this" {
  length    = 2
  separator = "-"
}

resource "azurerm_key_vault_secret" "login" {
  name         = "linux-login"
  value        = random_pet.this.id
  key_vault_id = data.azurerm_keyvault.this.id
}

resource "azurerm_kubernetes_cluster" "this" {
  name                                = var.aks_name
  location                            = data.azurerm_resource_group.this.location
  resource_group_name                 = data.azurerm_resource_group.this.name
  node_resource_group                 = coalesce(var.aks_cluster.node_resource_group, "${data.azurerm_resource_group.this.name}-MC")
  sku_tier                            = var.sku_kubernetes_cluster
  private_cluster_enabled             = true
  kubernetes_version                  = var.aks_cluster.kubernetes_version
  private_dns_zone_id                 = var.private_dns_zone_id != null ? var.private_dns_zone_id : "None"
  dns_prefix_private_cluster          = var.private_dns_zone_id != null ? var.aks_cluster.dns_prefix : null
  dns_prefix                          = var.private_dns_zone_id == null ? var.aks_cluster.dns_prefix : null
  local_account_disabled              = true
  automatic_upgrade_channel           = var.aks_cluster.automatic_upgrade_channel
  azure_policy_enabled                = true
  private_cluster_public_fqdn_enabled = var.private_dns_zone_id == null ? true : false
  http_application_routing_enabled    = false
  open_service_mesh_enabled           = coalesce(var.aks_cluster.open_service_mesh_enabled, false)

  default_node_pool {
    name                    = var.aks_cluster.default_node_pool.name
    vm_size                 = var.aks_cluster.default_node_pool.vm_size
    orchestrator_version    = coalesce(var.aks_cluster.default_node_pool.orchestrator_version, var.aks_cluster.kubernetes_version)
    auto_scaling_enabled    = true
    host_encryption_enabled = false
    node_public_ip_enabled  = false
    kubelet_disk_type       = "OS"
    max_pods                = var.aks_cluster.default_node_pool.max_pods
    node_labels             = var.aks_cluster.default_node_pool.node_labels
    os_disk_type            = var.aks_cluster.default_node_pool.os_disk_type
    os_disk_size_gb         = var.aks_cluster.default_node_pool.os_disk_size_gb
    os_sku                  = coalesce(var.aks_cluster.default_node_pool.os_sku, "Ubuntu")
    type                    = "VirtualMachineScaleSets"
    tags                    = var.additional_tags
    vnet_subnet_id          = data.azurerm_subnet.this.id
    zones                   = var.aks_cluster.default_node_pool.availability_zones
    max_count               = var.aks_cluster.default_node_pool.max_count
    min_count               = var.aks_cluster.default_node_pool.min_count
    node_count              = var.aks_cluster.default_node_pool.node_count
  }

  identity {
    type         = "UserAssigned"
    identity_ids = var.user_assigned_identity_id
  }

  dynamic "kubelet_identity" {
    for_each = var.kubelet_identity == null ? toset([]) : toset([1])

    content {
      client_id                 = var.kubelet_identity.client_id
      object_id                 = var.kubelet_identity.object_id
      user_assigned_identity_id = var.kubelet_identity.user_assigned_identity_id
    }
  }

  linux_profile {
    admin_username = random_pet.this.id
    ssh_key {
      key_data = tls_private_key.this.public_key_openssh
    }
  }

  windows_profile {
    admin_username = random_pet.this.id
    admin_password = random_password.this.result
  }

  dynamic "service_mesh_profile" {
    for_each = var.service_mesh_profile == null ? [] : [service_mesh_profile]
    content {
      mode                             = var.service_mesh_profile.mode
      external_ingress_gateway_enabled = var.service_mesh_profile.external_ingress_gateway_enabled
      internal_ingress_gateway_enabled = var.service_mesh_profile.internal_ingress_gateway_enabled
      revisions                        = [var.service_mesh_profile.revision]
    }
  }

  dynamic "workload_autoscaler_profile" {
    for_each = var.workload_autoscaler_profile == null ? [] : [var.workload_autoscaler_profile]

    content {
      keda_enabled                    = workload_autoscaler_profile.value.keda_enabled
      vertical_pod_autoscaler_enabled = workload_autoscaler_profile.value.vertical_pod_autoscaler_enabled
    }
  }

  network_profile {
    network_plugin      = "azure"
    outbound_type       = "userDefinedRouting"
    network_plugin_mode = "overlay"
    service_cidr        = "10.0.0.0/16"
    dns_service_ip      = "10.0.0.10"
    pod_cidr            = "15.0.0.0/16"
    network_policy      = "calico"
    load_balancer_sku   = "standard"
  }

  oidc_issuer_enabled       = var.aks_cluster.oidc_issuer_enabled
  workload_identity_enabled = var.aks_cluster.workload_identity_enabled

  tags = var.additional_tags
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = var.aks_cluster_worker_node_pools == null ? {} : var.aks_cluster_worker_node_pools

  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  name                  = each.key["name"]
  vm_size               = each.key["vm_size"]
  orchestrator_version  = lookup(each.value, "orchestrator_version", var.aks_cluster.kubernetes_version)
  vnet_subnet_id        = each.value["subnet_id"]

  auto_scaling_enabled = true
  mode                 = "User"

  os_sku          = lookup(each.value, "os_sku", null)
  os_disk_type    = lookup(each.value, "os_disk_type", null)
  os_disk_size_gb = lookup(each.value, "os_disk_size_gb", null)

  max_pods   = lookup(each.value, "max_pods", null)
  min_count  = each.value.min_count
  max_count  = each.value.max_count
  node_count = each.value.node_count

  node_labels = each.value["node_labels"]
  node_taints = coalesce(each.value["node_taints"], [])

  tags = var.additional_tags
}
