package terraform.analysis

import future.keywords.in

default allow = false

# Allow deployment if there are zero policy violations
allow {
    count(deny) == 0
}

# -------------------------------------------------------------
# RULE 1: Restrict Deployments to Allowed Regions (Free Account Quota)
# -------------------------------------------------------------
allowed_locations := ["canadacentral", "eastus", "eastus2", "centralus"]

deny[msg] {
    some resource in input.resource_changes
    resource.type in ["azurerm_resource_group", "azurerm_kubernetes_cluster", "azurerm_key_vault"]
    location := resource.change.after.location
    not location in allowed_locations
    msg := sprintf("[LOCATION POLICY VIOLATION] Prod resource '%v' specifies location '%v'. Allowed regions: %v", [resource.address, location, allowed_locations])
}

# -------------------------------------------------------------
# RULE 2: AKS Node Pool VM Size Restriction (Stay within 4 vCPU Free Limit)
# -------------------------------------------------------------
allowed_vm_skus := ["Standard_B2s", "Standard_B2ms", "Standard_DS2_v2", "Standard_D2s_v3"]

deny[msg] {
    some resource in input.resource_changes
    resource.type == "azurerm_kubernetes_cluster"
    node_pools := resource.change.after.default_node_pool
    some pool in node_pools
    not pool.vm_size in allowed_vm_skus
    msg := sprintf("[VM SIZE VIOLATION] Prod AKS cluster '%v' uses VM size '%v'. Only %v are permitted to stay within Free Tier limits.", [resource.address, pool.vm_size, allowed_vm_skus])
}

# -------------------------------------------------------------
# RULE 3: AKS Max Node Count Guard (Max 2 nodes per cluster for Free Tier)
# -------------------------------------------------------------
deny[msg] {
    some resource in input.resource_changes
    resource.type == "azurerm_kubernetes_cluster"
    node_pools := resource.change.after.default_node_pool
    some pool in node_pools
    pool.max_count > 2
    msg := sprintf("[NODE COUNT VIOLATION] Prod AKS cluster '%v' default node pool max_count is %v (maximum allowed on Free Tier is 2).", [resource.address, pool.max_count])
}

# -------------------------------------------------------------
# RULE 4: Key Vault RBAC Authorization Enforcement
# -------------------------------------------------------------
deny[msg] {
    some resource in input.resource_changes
    resource.type == "azurerm_key_vault"
    resource.change.after.rbac_authorization_enabled != true
    msg := sprintf("[KEYVAULT RBAC VIOLATION] Prod Key Vault '%v' must have 'rbac_authorization_enabled = true'.", [resource.address])
}

# -------------------------------------------------------------
# RULE 5: Production Environment Tag Enforcement
# -------------------------------------------------------------
deny[msg] {
    some resource in input.resource_changes
    resource.type in ["azurerm_resource_group", "azurerm_kubernetes_cluster", "azurerm_key_vault"]
    tags := resource.change.after.tags
    tags.Environment != "prod"
    msg := sprintf("[PROD TAG VIOLATION] Resource '%v' in Prod repo must have tag 'Environment = \"prod\"'. Found: '%v'", [resource.address, tags.Environment])
}

# -------------------------------------------------------------
# RULE 6: Mandatory Governance Tagging
# -------------------------------------------------------------
required_tags := ["Environment", "ManagedBy", "Project"]

deny[msg] {
    some resource in input.resource_changes
    resource.type in ["azurerm_resource_group", "azurerm_kubernetes_cluster", "azurerm_key_vault"]
    tags := resource.change.after.tags
    some req in required_tags
    not tags[req]
    msg := sprintf("[TAGGING VIOLATION] Prod resource '%v' is missing mandatory tag '%v'.", [resource.address, req])
}
