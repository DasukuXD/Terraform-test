output "name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.name
}

output "id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.id
}

output "fqdn" {
  description = "The FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "node_resource_group" {
  description = "The Resource Group that contains the Managed resources by the AKS service these should not be altered dierectly."
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}

output "kube_config" {
  description = "The kube config for the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.kube_config
  sensitive   = true
}
