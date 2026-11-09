output "cluster_name" {
  description = "AKS Cluster name"
  value       = azurerm_kubernetes_cluster.aks_cluster.name
}

output "cluster_id" {
  description = "AKS Cluster ID"
  value       = azurerm_kubernetes_cluster.aks_cluster.id
}

output "kube_config_raw" {
  description = "Raw kubeconfig file content"
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive   = true
}

output "oidc_issuer_url" {
  description = "OIDC Issuer URL for workload identity"
  value       = azurerm_kubernetes_cluster.aks_cluster.oidc_issuer_url
}

output "ssh_private_key_pem" {
  description = "Auto-generated SSH private key (if generated)"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}

output "ssh_public_key_openssh" {
  description = "Auto-generated SSH public key"
  value       = tls_private_key.ssh.public_key_openssh
}
