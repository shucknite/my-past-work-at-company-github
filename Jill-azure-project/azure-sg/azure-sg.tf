provider "azurerm" {
   features {}
}
resource "azurerm_resource_group" "example2" {
  name     = "example-resources2"
  location = "East Us"
}

resource "azurerm_network_security_group" "example2" {
  name                = "azure-sg"
  location            = azurerm_resource_group.example2.location
  resource_group_name = azurerm_resource_group.example2.name

  security_rule {
    name                       = "azure-sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3000"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}