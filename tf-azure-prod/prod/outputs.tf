output "resource_group_name" {
  description = "Production Resource Group name"
  value       = azurerm_resource_group.rg.name
}

output "aks_cluster_name" {
  description = "Production AKS cluster name"
  value       = module.aks.cluster_name
}

output "keyvault_name" {
  description = "Production Key Vault name"
  value       = module.keyvault.keyvault_name
}

output "service_principal_client_id" {
  description = "Production SPN Client ID"
  value       = module.service_principal.client_id
}
