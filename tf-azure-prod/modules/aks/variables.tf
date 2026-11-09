variable "cluster_name" {
  type        = string
  description = "Name of the Azure Kubernetes cluster"
}

variable "location" {
  type        = string
  description = "Azure region where the cluster will be deployed"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the parent resource group"
}

variable "node_pool_name" {
  type        = string
  description = "Name of the default AKS node pool"
  default     = "prodpool"
}

variable "vm_size" {
  type        = string
  description = "Virtual machine SKU for the node pool (chosen for Azure Free Tier compliance)"
  default     = "Standard_B2s"
}

variable "auto_scaling_enabled" {
  type        = bool
  description = "Enable cluster autoscaling"
  default     = true
}

variable "min_count" {
  type        = number
  description = "Minimum node count for autoscaling"
  default     = 1
}

variable "max_count" {
  type        = number
  description = "Maximum node count for autoscaling (keep <= 2 for Azure Free account quota)"
  default     = 2
}

variable "kubernetes_version" {
  type        = string
  description = "Specific Kubernetes version (leave empty to query latest non-preview)"
  default     = ""
}

variable "client_id" {
  type        = string
  description = "Service Principal client ID"
}

variable "client_secret" {
  type        = string
  description = "Service Principal client secret"
  sensitive   = true
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key contents. Leave empty to auto-generate with TLS provider"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags for the AKS cluster"
  default     = {}
}
