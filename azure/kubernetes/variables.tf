variable "resource_group_name" {
    description = "The resource group name to be imported"
    type        = string
}

variable "public_ssh_key" {
    type        = string
    description = "Custom public key to access to AKS cluster"
    default     = ""
}

variable "prefix" {
    description = "The prefix for the resources created in Azure RG"
    type        = string
}

variable "sku_tier" {
    type        = string
    description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid"
    default     = "Free"
}

variable "admin_username" {
    type        = string
    description = "Node Unix admin name"
}

variable "agent_count" {
    type        = number
    description = "Number of agents in Node Pool"
    default     = 3
}

variable "agent_size" {
    type        = string
    description = "VM size for AKS nodes"
    default     = "Standard_D2s_v3"
}

variable "os_disk_size_gb" {
    type        = number
    description = "AKS Node Disk size"
    default     = 20
}

variable "vnet_subnet_id" {
    type        = string
    description = "(optional) ID for AKS Nodes"
    default     = null
}

variable "enable_http_application_routing" {
    type        = bool
    description = "Enable HTTP Application Routing (!!!RECREATION!!!)"
    default     = false
}

variable "client_id" {
    type        = string
    description = "(optional) appId of SP for AKS"
    default     = ""
}

variable "enable_azure_policy" {
    type        = bool
    description = "(optional) Enable Az Policy"
    default     = false
}

variable "enable_log_analytics_workspace" {
    type        = bool
    description = "Enable the creation for azurerm_log_analytics_workspace"
    default     = true
}

variable "tags" {
    type        = map(string)
    description = "Tags for resources"
    default     = {}
}

variable "log_analytics_workspace_sku" {
    type        = string
    description = "SKU for Log Analytics"
    default     = "PerGB2018"
}

variable "log_retention" {
    type        = number
    description = "Log retention in days"
    default     = 30
}
