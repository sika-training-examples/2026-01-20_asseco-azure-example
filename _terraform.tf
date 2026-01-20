terraform {
  backend "azurerm" {
    resource_group_name  = "asseco-terraform-states"
    storage_account_name = "assecoterraform3430"
    container_name       = "terraform-states"
    key                  = "ondrejsika/terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.57.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "200acaec-2d60-43ad-915a-e8f5352a4ba7" // SikaLabs TRAINING
}
