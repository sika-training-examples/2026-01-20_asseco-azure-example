resource "azurerm_resource_group" "training" {
  lifecycle {
    ignore_changes = [
      tags.created_at
    ]
  }

  name     = "ondrejsika"
  location = "westeurope"

  tags = {
    team       = "cz-cloud-brno"
    created_at = timestamp()
  }
}
