# provider "azurerm" {
#    features {}
# }
# resource "azurerm_resource_group" "example1" {
#   name     = "example-resources1"
#   location = "East US"
# }

# resource "azurerm_virtual_network" "example1" {
#   name                = "example-network"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.example1.location
#   resource_group_name = azurerm_resource_group.example1.name
# }

# resource "azurerm_subnet" "example1" {
#   name                 = "internal"
#   resource_group_name  = azurerm_resource_group.example1.name
#   virtual_network_name = azurerm_virtual_network.example1.name
#   address_prefixes     = ["10.0.2.0/24"]
# }

# resource "azurerm_network_interface" "example" {
#   name                = "azure-nic"
#   location            = azurerm_resource_group.example1.location
#   resource_group_name = azurerm_resource_group.example1.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.example1.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_linux_virtual_machine" "example1" {
#   name                = "azure-machine"
#   resource_group_name = azurerm_resource_group.example1.name
#   location            = azurerm_resource_group.example1.location
#   size                = "Standard_F2"
#   admin_username      = "shucknite"
#   network_interface_ids = [
#     azurerm_network_interface.example.id,
#   ]

#   admin_ssh_key {
#     username   = "shucknite"
#     public_key = file("azure-key")
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts"
#     version   = "latest"
#   }
# }


## <https://www.terraform.io/docs/providers/azurerm/index.html>
provider "azurerm" {
  features {}
}

## <https://www.terraform.io/docs/providers/azurerm/r/resource_group.html>
resource "azurerm_resource_group" "rg" {
  name     = "TerraformTesting"
  location = "eastus"
}

## <https://www.terraform.io/docs/providers/azurerm/r/availability_set.html>
resource "azurerm_availability_set" "DemoAset" {
  name                = "example-aset"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

## <https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html>
resource "azurerm_virtual_network" "vnet1" {
  name                = "vNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

## <https://www.terraform.io/docs/providers/azurerm/r/subnet.html> 
# resource "azurerm_subnet" "subnet" {
#   name                 = "internal"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefix       = ["10.0.2.0/24"]
# }

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes      = ["10.0.2.0/24, 10.0.3.0/24"]
}

## <https://www.terraform.io/docs/providers/azurerm/r/network_interface.html>
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

## <https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html>
resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "shucknite"
  admin_password      = "signal12@"
  availability_set_id = azurerm_availability_set.DemoAset.id
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}