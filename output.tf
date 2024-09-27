output "app_service_url" {
  value = azurerm_app_service.website.default_site_hostname
}

output "sql_server_connection_string" {
  value = azurerm_sql_server.sql_server.administrator_login
}