resource "azurerm_service_plan" "main" {
  name                = var.service_plan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "B1"

  depends_on = [
    azurerm_resource_group.main
  ]
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "main" {
  name                = var.webapp_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  connection_string {
    name = "SQLConnection"
    type = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.main.name};User Id=${azurerm_mssql_server.main.administrator_login};Password='${azurerm_mssql_server.main.administrator_login_password}';"
  }

  depends_on = [
    azurerm_service_plan.main,
    azurerm_mssql_server.main,
    azurerm_mssql_database.main
  ]
}

#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "src_control" {
  app_id   = azurerm_linux_web_app.main.id
  repo_url = var.source_control["repo_url"]
  branch   = var.source_control["branch"]
  # use_manual_integration = true
}

resource "azurerm_source_control_token" "scm_tk" {
  type  = "GitHub"
  token = var.scm_token
}

