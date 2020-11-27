output "vm_ids" {
  value = concat(azurerm_virtual_machine.main.*.id)
}

output "network_interface_ids" {
  value = azurerm_network_interface.main.*.id
}

output "network_interface_private_ip" {
  value = azurerm_network_interface.main.*.private_ip_address
}

output "availability_set_id" {
  value = azurerm_availability_set.main.id
}

output "network_interface_public_ip" {
  value = azurerm_public_ip.main.*.fqdn
}
