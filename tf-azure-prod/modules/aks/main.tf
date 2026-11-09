data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  k8s_version    = var.kubernetes_version != "" ? var.kubernetes_version : data.azurerm_kubernetes_service_versions.current.latest_version
  ssh_public_key = var.ssh_public_key != "" ? var.ssh_public_key : tls_private_key.ssh.public_key_openssh
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.cluster_name}-dns"
  kubernetes_version  = local.k8s_version
  node_resource_group = "${var.resource_group_name}-nrg"

  default_node_pool {
    name                 = var.node_pool_name
    vm_size              = var.vm_size
    auto_scaling_enabled = var.auto_scaling_enabled
    min_count            = var.min_count
    max_count            = var.max_count
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
    tags                 = var.tags
  }

  node_provisioning_profile {
    mode = "Manual"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = local.ssh_public_key
    }
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  tags = var.tags
}
