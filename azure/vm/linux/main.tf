resource "random_id" "main" {
    keepers = {
        vm_hostname = var.vm_hostname
    }

    byte_length = 6
}

resource "azurerm_storage_account" "main" {
    count                    = var.boot_diagnostics == "true" ? 1 : 0
    name                     = "bootdiag-${lower(random_id.main.hex)}"
    resource_group_name      = data.azurerm_resource_group.main.name
    location                 = data.azurerm_resource_group.main.location
    account_tier             = "${element(split("_", var.boot_sa_type),0)}"
    account_replication_type = "${element(split("_", var.boot_sa_type),1)}"

    tags = var.tags
}

resource "azurerm_availability_set" "main" {
    name                         = "${var.vm_hostname}-avset"
    location                     = data.azurerm_resource_group.main.location
    resource_group_name          = data.azurerm_resource_group.main.name
    platform_fault_domain_count  = 2
    platform_update_domain_count = 2
    managed                      = true
}

resource "azurerm_public_ip" "main" {
    count                        = var.pub_ip_num
    name                         = "${var.vm_hostname}-${count.index}-publicIP"
    location                     = data.azurerm_resource_group.main.location
    resource_group_name          = data.azurerm_resource_group.main.name
    public_ip_address_allocation = var.public_ip_address_allocation
    domain_name_label            = "${element(var.public_ip_dns, count.index)}"
}

resource "azurerm_network_interface" "main" {
    count                       = var.instances_num
    name                        = "nic-${var.vm_hostname}-${count.index}"
    location                    = data.azurerm_resource_group.main.location
    resource_group_name         = data.azurerm_resource_group.main.name
    network_security_group_id   = var.nsg_id

    ip_configuration {
        name                          = "ipconfigs${count.index}"
        subnet_id                     = var.vnet_subnet_id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${length(azurerm_public_ip.vm.*.id) > 0 ? element(concat(azurerm_public_ip.vm.*.id, list("")), count.index) : ""}"
    } 
}

resource "azurerm_virtual_machine" "main" {
    name                            = "${var.prefix}-${var.vm_hostname}"
    location                        = data.azurerm_resource_group.main.location
    resource_group_name             = data.azurerm_resource_group.main.name
    availability_set_id             = azurerm_availability_set.main.id
    vm_size                         = var.vm_size
    network_interface_ids           = ["${element(azurerm_network_interface.vm.*.id, count.index)}"]
    delete_os_disk_on_termination   = var.delete_os_disk_on_termination

    storage_image_reference {
        id          = var.vm_os_id
        publisher   = var.vm_os_publisher
        offer       = var.vm_os_offer
        sku         = var.vm_os_sku
        version     = var.vm_os_version
    }

    storage_os_disk {
        name                = "osdisk-${var.vm_hostname}-${count.index}"
        create_option       = "FromImage"
        caching             = "ReadWrite"
        managed_disk_type   = var.storage_account_type  
    }

    os_profile {
        computer_name       = "${var.vm_hostname}${count.index}"
        admin_username      = var.admin_username
        admin_password      = var.admin_password
    }

    os_profile_linux_config {
        disable_password_authentication = true

        ssh_keys {
            path        = "/home/${var.admin_username}/.ssh/authorized_keys"
            key_data    = file("${var.ssh_key}") 
        }
    }

    tags = var.tags

    boot_diagnostics {
        enabled     = var.boot_diagnostics
        storage_uri = var.boot_diagnostics == "true" ? join(",", azurerm_storage_account.main.*.primary_blob_endpoint) : ""
    }

}
