resource "azurerm_virtual_network" "training" {
  lifecycle {
    ignore_changes = [
      tags["created_at"]
    ]
  }

  tags = {
    team       = "cz-cloud-brno"
    created_at = timestamp()
  }

  name                = "${azurerm_resource_group.training.name}-net"
  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name
  address_space       = ["10.10.0.0/16"]
}
