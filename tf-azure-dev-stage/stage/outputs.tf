output "resource_group_name" {
  description = "Staging Resource Group name"
  value       = azurerm_resource_group.rg.name
}

output "aks_cluster_name" {
  description = "Staging AKS cluster name"
  value       = module.aks.cluster_name
}

output "keyvault_name" {
  description = "Staging Key Vault name"
  value       = module.keyvault.keyvault_name
}

output "service_principal_client_id" {
  description = "Staging SPN Client ID"
  value       = module.service_principal.client_id
}

