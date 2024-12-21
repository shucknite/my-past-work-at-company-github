terraform {
  backend "azurerm" {
    #   subscription_id       = "da74xxxx-9c9a-xxxx-8fae-xxxxxxxxxxxx"
    subscription_id      = ""
    resource_group_name  = "storage-account-group"
    storage_account_name = "storageaccountnamejill1" # Storage account used for backend
    container_name       = "blogstate"
    key                  = "terraform.tfstate.aks" # Terraform State file
  }
}