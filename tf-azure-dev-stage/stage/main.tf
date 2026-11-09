data "azurerm_subscription" "current" {}

locals {
  sub_id = var.subscription_id != "" ? var.subscription_id : data.azurerm_subscription.current.subscription_id
}

# Staging Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

# Service Principal for Staging
module "service_principal" {
  source                 = "../modules/ServicePrincipal"
  service_principal_name = var.service_principal_name

  depends_on = [azurerm_resource_group.rg]
}

# Assign Contributor Role to Service Principal (scoped to resource group)
resource "azurerm_role_assignment" "spn_contributor" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = module.service_principal.service_principal_object_id

  depends_on = [module.service_principal]
}

# Staging Key Vault
module "keyvault" {
  source              = "../modules/keyvault"
  keyvault_name       = var.keyvault_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  depends_on = [azurerm_resource_group.rg]
}

# Store Service Principal Secret in Key Vault
resource "azurerm_key_vault_secret" "spn_client_secret" {
  name         = "spn-client-secret"
  value        = module.service_principal.client_secret
  key_vault_id = module.keyvault.keyvault_id

  depends_on = [module.keyvault, module.service_principal]
}

# Staging AKS Cluster
module "aks" {
  source              = "../modules/aks"
  cluster_name        = var.cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  node_pool_name      = var.node_pool_name
  vm_size             = var.vm_size
  client_id           = module.service_principal.client_id
  client_secret       = module.service_principal.client_secret
  tags                = var.tags

  depends_on = [
    azurerm_role_assignment.spn_contributor,
    module.keyvault
  ]
}

# Store auto-generated SSH private key in Key Vault
resource "azurerm_key_vault_secret" "aks_ssh_private_key" {
  name         = "aks-ssh-private-key"
  value        = module.aks.ssh_private_key_pem
  key_vault_id = module.keyvault.keyvault_id

  depends_on = [module.keyvault, module.aks]
}

# Export kubeconfig locally
resource "local_file" "kubeconfig" {
  filename        = "${path.module}/kubeconfig"
  content         = module.aks.kube_config_raw
  file_permission = "0600"
}

