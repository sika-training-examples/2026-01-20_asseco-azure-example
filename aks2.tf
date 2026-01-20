data "azurerm_subnet" "training2" {
  resource_group_name  = "asseco-net"
  virtual_network_name = "asseco-net"
  name                 = "ondrej2"
}

resource "azurerm_kubernetes_cluster" "training2" {
  lifecycle {
    ignore_changes = [
      tags["created_at"]
    ]
  }

  name                = "${azurerm_resource_group.training.name}2-aks"
  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name
  dns_prefix          = join("", regexall("[a-z0-9]+", lower(azurerm_resource_group.training.name)))

  default_node_pool {
    name                        = "${join("", regexall("[a-z0-9]+", lower(azurerm_resource_group.training.name)))}2"
    temporary_name_for_rotation = "tmp"
    node_count                  = 1
    vm_size                     = "standard_d2ds_v6"
    vnet_subnet_id              = data.azurerm_subnet.training2.id

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
