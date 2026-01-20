resource "azurerm_resource_group" "training" {
  name     = "ondrejsika"
  location = "westeurope"

  tags = {
    team = "cz-cloud-brno"
    created_at = timestamp()
  }
}
