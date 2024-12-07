
output "name" {
  description = "The name of the virtual network."
  value       = azurerm_virtual_network.this.name
}

output "id" {
  description = "The ID of the virtual network."
  value       = azurerm_virtual_network.this.id
}

output "location" {
  description = "value of the location of the virtual network."
  value       = azurerm_virtual_network.this.location
}

output "subnet" {
  description = "IDs of the subnets."
  value       = [for x in azurerm_azurerm_subnet.this : x.id]
}

output "map_subnet_ids" {
  description = "Map of subnet ids"
  value = {
    for x in azurerm_subnet.this : x.name => x.id
  }
}
