# SQL database server
resource "azurerm_mssql_server" "main" {
  name                         = var.db_detail.db_server_name
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = var.db_detail.db_server_version
  administrator_login          = var.db_detail.admin_login
  administrator_login_password = var.db_detail.admin_login_pwd
}

# SQL database
resource "azurerm_mssql_database" "main" {
  name           = var.db_detail.db_name
  server_id      = azurerm_mssql_server.main.id
  collation      = var.db_detail.collation
  license_type   = var.db_detail.license_type
  max_size_gb    = 2
  sku_name       = var.db_detail.sku_name

  depends_on = [
    azurerm_mssql_server.main
  ]
}

# resource "azurerm_mssql_firewall_rule" "allowClient" {
#   name             = "AllowClientIP"
#   server_id        = azurerm_mssql_server.main.id
#   start_ip_address = "105.113.30.135"
#   end_ip_address   = "105.113.30.135"

#   depends_on = [
#     azurerm_mssql_server.main
#   ]
# }