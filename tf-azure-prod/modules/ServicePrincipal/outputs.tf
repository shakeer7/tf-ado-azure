output "service_principal_name" {
  description = "Display name of the Service Principal"
  value       = azuread_service_principal.main.display_name
}

output "service_principal_object_id" {
  description = "Object ID of the Service Principal"
  value       = azuread_service_principal.main.object_id
}

output "service_principal_tenant_id" {
  description = "Tenant ID of the Service Principal"
  value       = azuread_service_principal.main.application_tenant_id
}

output "client_id" {
  description = "Client (Application) ID of the Azure AD Application"
  value       = azuread_application.main.client_id
}

output "client_secret" {
  description = "Secret password of the Service Principal"
  value       = azuread_service_principal_password.main.value
  sensitive   = true
}
