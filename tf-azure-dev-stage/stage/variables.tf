variable "environment" {
  type        = string
  description = "Environment identifier"
  default     = "stage"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "canadacentral"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID for role assignment"
  default     = ""
}

variable "rg_name" {
  type        = string
  description = "Resource Group Name for Staging"
  default     = "rg-tf-stage-free"
}

variable "service_principal_name" {
  type        = string
  description = "Azure AD SPN Name for Staging"
  default     = "spn-tf-stage-free"
}

variable "keyvault_name" {
  type        = string
  description = "Key Vault Name for Staging (3-24 alphanum globally unique)"
  default     = "kv-tf-stg-free-01"
}

variable "cluster_name" {
  type        = string
  description = "AKS cluster name for Staging"
  default     = "aks-stg-free-01"
}

variable "node_pool_name" {
  type        = string
  description = "Node pool name for Staging"
  default     = "stgpool"
}

variable "vm_size" {
  type        = string
  description = "VM size for AKS nodes (Standard_B2s uses 2 vCPUs)"
  default     = "Standard_B2s"
}

variable "tags" {
  type        = map(string)
  description = "Standard resource tags"
  default = {
    Environment = "stage"
    ManagedBy   = "Terraform"
    Project     = "tf-ado"
  }
}

