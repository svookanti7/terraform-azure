provider "azurerm" {
  version         = "=2.5.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  features {}
}

resource "azurerm_resource_group" "infosys-poc" {
  name     = var.resource_group_name
  location = var.location
}


resource "azurerm_sql_server" "infosys-poc" {
  name                         = var.sqlserver_name
  resource_group_name          = azurerm_resource_group.infosys-poc.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin
  administrator_login_password = var.password

  tags = {
    environment = "infosys-poc"
  }
}


resource "azurerm_storage_account" "sqlserver_storage" {
  name                     = var.storageaccount_name
  resource_group_name      = azurerm_resource_group.infosys-poc.name
  location                 = azurerm_resource_group.infosys-poc.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_database" "serveless_database" {
  name                = var.database_name
  resource_group_name = azurerm_resource_group.infosys-poc.name
  location            = azurerm_resource_group.infosys-poc.location
  server_name         = azurerm_sql_server.infosys-poc.name
  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.sqlserver_storage.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.sqlserver_storage.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }



  tags = {
    environment = "infosys-poc"
  }
}