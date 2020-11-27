provider "azurerm" {
    features {}
}

module "name" {
    source         = "./modules/ssh-key"
    public_ssh_key = var.public_ssh_key == "" ? "" : var.public_ssh_key
    
}

resource "azurerm_kubernetes_cluster" "main" {
    name                = "${var.prefix}-aks"
    location            = data.azurerm_resource_group.main.location
    resource_group_name = data.azurerm_resource_group.main.name
    dns_prefix          = var.prefix
    sku_tier            = var.sku_tier

    linux_profile {
        admin_username  = var.admin_username

        ssh_key {
            key_data = replace(var.public_ssh_key == "" ? module.ssh-key.public_ssh_key : var.public_ssh_key, "\n", "")
        }
    }

    default_node_pool {
        name            = "nodepool"
        node_count      = var.agent_count
        vm_size         = var.agent_size
        os_disk_size_gb = var.os_disk_size_gb
        vnet_subnet_id  = var.vnet_subnet_id
    }

    dynamic identity {
        for_each = var.client_id == "" || var.client_secret == "" ? ["identity"] : []
        content {
            type = "SystemAssigned"
        }
    }

    addon_profile {
        http_application_routing {
            enabled = var.enable_http_application_routing
        }
        dynamic azure_policy {
            for_each = var.enable_azure_policy ? ["azure_policy"] : []
            content {
                enabled = true
            }
        }
        dynamic oms_agent {
            for_each = var.enable_log_analytics_workspace ? ["log_analytics"] : []
            content {
                enabled                    = true
                log_analytics_workspace_id = azurerm_log_analytics_workspace.main[0].id
            }
        }
    }

    tags = var.tags
}

resource "azurerm_log_analytics_workspace" "main" {
    count               = var.enable_log_analytics_workspace ? 1 : 0
    name                = "${var.prefix}-workspace"
    location            = data.azurerm_resource_group.main.location
    resource_group_name = data.azurerm_resource_group.main.name
    sku                 = var.log_analytics_workspace_sku
    retention_in_days   = var.log_retention

    tags = var.tags
}

resource "azurerm_log_analytics_solution" "main" {
    count                   = var.enable_log_analytics_workspace ? 1 : 0
    solution_name           = "${var.prefix}-insights"
    location                = data.azurerm_resource_group.main.location
    resource_group_name     = data.azurerm_resource_group.main.name
    workspace_resource_id   = azurerm_log_analytics_workspace.main[0].id
    workspace_name          = azurerm_log_analytics_workspace.main[0].name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}
