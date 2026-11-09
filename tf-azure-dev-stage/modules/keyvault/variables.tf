variable "keyvault_name" {
  type        = string
  description = "Globally unique name for the Azure Key Vault"
}

variable "location" {
  type        = string
  description = "Azure region where the Key Vault will be created"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name where Key Vault is located"
}

variable "tags" {
  type        = map(string)
  description = "Tags to attach to the Key Vault"
  default     = {}
}

