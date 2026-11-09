environment            = "dev"
location               = "canadacentral"
rg_name                = "rg-tf-dev-free"
service_principal_name = "spn-tf-dev-free"
keyvault_name          = "kv-tf-dev-free-01"
cluster_name           = "aks-dev-free-01"
node_pool_name         = "devpool"
vm_size                = "Standard_B2s"
subscription_id        = ""

tags = {
  Environment = "dev"
  ManagedBy   = "Terraform"
  Project     = "tf-ado"
}

