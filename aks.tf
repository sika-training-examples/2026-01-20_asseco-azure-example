resource "azurerm_subnet" "aks-training" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.training.name
  resource_group_name  = azurerm_resource_group.training.name
  address_prefixes     = ["10.10.0.0/24"]
}

resource "azurerm_kubernetes_cluster" "training" {
  lifecycle {
    ignore_changes = [
      tags["created_at"]
    ]
  }

  name                = "${azurerm_resource_group.training.name}-aks"
  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name
  dns_prefix          = join("", regexall("[a-z0-9]+", lower(azurerm_resource_group.training.name)))

  default_node_pool {
    name                        = join("", regexall("[a-z0-9]+", lower(azurerm_resource_group.training.name)))
    temporary_name_for_rotation = "tmp"
    node_count                  = 1
    vm_size                     = "standard_d2ds_v6"
    vnet_subnet_id              = azurerm_subnet.aks-training.id

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    team       = "cz-cloud-brno"
    created_at = timestamp()
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "${join("", regexall("[a-z0-9]+", lower(azurerm_resource_group.training.name)))}2"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.training.id
  vm_size               = "standard_d2ds_v6"
  node_count            = 3
  vnet_subnet_id        = azurerm_subnet.aks-training.id

  upgrade_settings {
    drain_timeout_in_minutes      = 0
    max_surge                     = "10%"
    node_soak_duration_in_minutes = 0
  }
}

output "aks_training_connect_command" {
  value = "az aks get-credentials --resource-group ${azurerm_kubernetes_cluster.training.resource_group_name} --name ${azurerm_kubernetes_cluster.training.name} --overwrite-existing"
}
