environment            = "stage"
location               = "canadacentral"
rg_name                = "rg-tf-stage-free"
service_principal_name = "spn-tf-stage-free"
keyvault_name          = "kv-tf-stg-free-01"
cluster_name           = "aks-stg-free-01"
node_pool_name         = "stgpool"
vm_size                = "Standard_B2s"
subscription_id        = ""

tags = {
  Environment = "stage"
  ManagedBy   = "Terraform"
  Project     = "tf-ado"
}

