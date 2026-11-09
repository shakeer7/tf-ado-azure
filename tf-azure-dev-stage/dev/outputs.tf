output "resource_group_name" {
  description = "Dev Resource Group name"
  value       = azurerm_resource_group.rg.name
}

output "aks_cluster_name" {
  description = "Dev AKS cluster name"
  value       = module.aks.cluster_name
}

output "keyvault_name" {
  description = "Dev Key Vault name"
  value       = module.keyvault.keyvault_name
}

output "service_principal_client_id" {
  description = "Dev SPN Client ID"
  value       = module.service_principal.client_id
}

