terraform {
  backend "azurerm" {
    #   subscription_id       = ""
    subscription_id      = ""
    resource_group_name  = ""
    storage_account_name = "" # Storage account used for backend
    container_name       = ""
    key                  = "" # Terraform State file
  }
}