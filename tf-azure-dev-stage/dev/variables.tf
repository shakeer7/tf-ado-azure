variable "environment" {
  type        = string
  description = "Environment identifier"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Azure region (Canada Central fits free accounts well)"
  default     = "canadacentral"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID for role assignment"
  default     = ""
}

variable "rg_name" {
  type        = string
  description = "Resource Group Name for Dev"
  default     = "rg-tf-dev-free"
}

variable "service_principal_name" {
  type        = string
  description = "Azure AD SPN Name for Dev"
  default     = "spn-tf-dev-free"
}

variable "keyvault_name" {
  type        = string
  description = "Key Vault Name for Dev (3-24 alphanum globally unique)"
  default     = "kv-tf-dev-free-01"
}

variable "cluster_name" {
  type        = string
  description = "AKS cluster name for Dev"
  default     = "aks-dev-free-01"
}

variable "node_pool_name" {
  type        = string
  description = "Node pool name for Dev"
  default     = "devpool"
}

variable "vm_size" {
  type        = string
  description = "VM size for AKS nodes (Standard_B2s uses 2 vCPUs, perfect for 4 vCPU Free Tier limit)"
  default     = "Standard_B2s"
}

variable "tags" {
  type        = map(string)
  description = "Standard resource tags"
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "tf-ado"
  }
}

