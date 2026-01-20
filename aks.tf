resource "azurerm_kubernetes_cluster" "training" {
  name                = "${azurerm_resource_group.training.name}-aks"
  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name
  dns_prefix          = join("", regexall("[a-z0-9]+", lower(azurerm_resource_group.training.name)))

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    team = "cz-cloud-brno"
    created_at = timestamp()
  }
}
