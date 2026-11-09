environment            = "prod"
location               = "canadacentral"
rg_name                = "rg-tf-prod-free"
service_principal_name = "spn-tf-prod-free"
keyvault_name          = "kv-tf-prd-free-01"
cluster_name           = "aks-prd-free-01"
node_pool_name         = "prodpool"
vm_size                = "Standard_B2s"
subscription_id        = ""

tags = {
  Environment = "prod"
  ManagedBy   = "Terraform"
  Project     = "tf-ado"
}

