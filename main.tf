terraform {
  backend "azurerm" {
    resource_group_name  = "infosys-poc"
    storage_account_name = "infosys"
    container_name       = "infosys"
    key                  = "poc.tfstate"
    access_key           = "4y8GGdIuwbM9SkR5dWwLibh6TfzNU7U3UCA+2rjDnl2/Dm4iXZV39ceSFtUZZfrd7ophkZ/pDKd51EuRh4w3KQ=="
  }
}
provider "azurerm" {
  version = "=1.44.0"  
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  features {}
}


resource "azure_hosted_service" "terraform-service" {
  name               = "terraform-service"
  location           = "North Europe"
  ephemeral_contents = false
  description        = "Hosted service created by Terraform."
  label              = "tf-hs-01"
}

resource "azure_instance" "web" {
  name                 = "terraform-test"
  hosted_service_name  = "azure_hosted_service.terraform-service.name"
  image                = "Ubuntu Server 14.04 LTS"
  size                 = "Basic_A1"
  storage_service_name = "yourstorage"
  location             = "West US"
  username             = "terraform"
  password             = "Pass!admin123"
  domain_name          = "contoso.com"
  domain_ou            = "OU=Servers,DC=contoso.com,DC=Contoso,DC=com"
  domain_username      = "Administrator"
  domain_password      = "Pa$$word123"

  endpoint {
    name         = "SSH"
    protocol     = "tcp"
    public_port  = 22
    private_port = 22
  }
}