resource "azurerm_resource_group" "law" {
  name     = "asseco-law"
  location = "westeurope"
}

resource "azurerm_log_analytics_workspace" "asseco" {
  name                = "asseco"
  location            = azurerm_resource_group.law.location
  resource_group_name = azurerm_resource_group.law.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
