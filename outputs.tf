output "resource_group_name" {
  value = azurerm_resource_group.infosys-poc
}

output "sqlserver_name" {
value =  azurerm_sql_server.infosys-poc.id
}

