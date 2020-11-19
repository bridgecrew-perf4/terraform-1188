variable "prefix" {
    type        = string
    description = "The prefix for the resources created in Azure RG"
    default     = ""
}

variable "tags" {
    type        = map(string)
    description = "(optional) tags to assosiate with current resources"
    default     = {}
}

variable "resource_group_name" {
    type        = string
    description = "The resource group name to be imported"
}

variable "vm_hostname" {
    type        = string
    description = "Hostname which will be assigned to VM"
}

variable "boot_diagnostics" {
    type        = string
    description = "Enable boot diagnostics"
    default     = "false"
}

variable "boot_sa_type" {
    type        = string
    description = "(optional) Storage Account type"
    default     = "Standard_LRS"
}

variable "storage_account_type" {
    type        = string
    description = "Type of SA for VM"
    default     = "Premium_LRS"
}

variable "vm_size" {
    type        = string
    description = "Size of VM which will be created"
    default     = "Standard_DS1_V2"
}

variable "instances_num" {
    type        = number
    description = "Number of instances to be created"
    default     = 1
}

variable "pub_ip_num" {
    type        = number
    description = "Number of public IPs to be created"
    default     = 1
}

variable "nsg_id" {
    type        = string
    description = "(optional) Id of created and configured Network Security Group"
    default     = ""
}

variable "vnet_subnet_id" {
    type        = string
    description = "Id of Virtual Network for NIC"
}

variable "public_ip_address_allocation" {
    type        = string
    description = "How IP will assigned"
    default     = "dynamic"
}

variable "public_ip_dns" {
    type        = list(string)
    description = "(optional) Doman name label per IP unique per DC"
    default     = [""]
}

variable "delete_os_disk_on_termination" {
    type        = string
    description = "Delete OS on VM termination"
    default     = "false"
}

variable "vm_os_id" {
    type        = string
    description = "Provide the ID of AMI what you'd like to use"
    default     = ""
}

variable "vm_os_publisher" {
    type        = string
    description = "Publisher of AMI"
    default     = ""
}

variable "vm_os_offer" {
    type        = string
    description = "Offer of AMI"
    default     = ""
}

variable "vm_os_sku" {
    type        = string
    description = "SKU of AMI"
    default     = ""
}

variable "vm_os_version" {
    type        = string
    description = "Version of AMI"
    default     = ""
}

variable "admin_username" {
    type        = string
    description = "Admin Username for VM"
    default     = ""
}

variable "admin_password" {
    type        = string
    description = "Default password for SUDO user"
    default     = ""
}

variable "ssh_key" {
    type        = string
    description = "Path for public ssh key"
    default     = "~/.ssh/id_rsa.pub"
}
