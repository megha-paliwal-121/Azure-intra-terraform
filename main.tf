provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}
#Define Azure App Service for Website and API
resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "my-app-service-plan"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "website" {
  name                = "my-website"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
}

resource "azurerm_app_service" "api" {
  name                = "my-api-service"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
}

resource "azurerm_storage_account" "storage" {
  name                     = "mystorageaccount"
  resource_group_name       = azurerm_resource_group.main.name
  location                  = azurerm_resource_group.main.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
}
# Define Azure SQL Database
resource "azurerm_sql_server" "sql_server" {
  name                         = "my-sql-server"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = "adminuser"
  administrator_login_password = "AdminPassword123"
}

resource "azurerm_sql_database" "sql_database" {
  name                = "my-database"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  server_name         = azurerm_sql_server.sql_server.name
  sku_name            = "S0"
}
#Define Azure Redis Cache
resource "azurerm_redis_cache" "redis" {
  name                = "my-redis-cache"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  capacity            = 1
  family              = "C"
  sku_name            = "Standard"
}
#Define Blob Storage
resource "azurerm_storage_account" "storage" {
  name                     = "mystorageaccount"
  resource_group_name       = azurerm_resource_group.main.name
  location                  = azurerm_resource_group.main.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
}
#Define Azure API Management
resource "azurerm_api_management" "apim" {
  name                = "my-api-management"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  publisher_name      = "My Company"
  publisher_email     = "admin@mycompany.com"
  sku_name            = "Developer_1"
}
#Define Virtual Network and VPN Gateway
resource "azurerm_virtual_network" "vnet" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = "my-vpn-gateway"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw1"
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet.id
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "vpn-gateway-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
}
#Define Azure Active Directory (AAD) Integration
resource "azurerm_ad_domain_service" "ad_domain" {
  name                = "mydomain"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  domain_name         = "mydomain.com"
  sku                 = "Standard"
  domain_controller_ip {
    primary = "10.0.1.4"
    secondary = "10.0.1.5"
  }
}
