provider "azurerm" {
   features {}
}
resource "azurerm_resource_group" "example2" {
  name     = "example-resources2"
  location = "East Us"
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "my-aks-demo"
  resource_group_name = azurerm_resource_group.example2.name
  location            = azurerm_resource_group.example2.location
  dns_prefix          = "my-aks-demo"

  default_node_pool {
    name       = "myakspool"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "my_aks_pool"
  }
}

# az aks create --resource-group $resourceGroupjill --name $clusterjill --node-count 2