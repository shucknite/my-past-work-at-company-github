provider "azurerm" {
   features {}
}
resource "azurerm_resource_group" "acr-resources-group" {
  name     = "acr-resources-group"
  location = "East US"
}

resource "azurerm_container_registry" "acr" {
  name                = "acrcontainerregistry2"
  resource_group_name = azurerm_resource_group.acr-resources-group.name
  location            = azurerm_resource_group.acr-resources-group.location
  sku                 = "Premium"
  admin_enabled       = false
  georeplications {
    location                = "East US 2"
    zone_redundancy_enabled = true
    tags                    = {}
  }
  georeplications {
    location                = "East US 2"
    zone_redundancy_enabled = true
    tags                    = {}
  }
}