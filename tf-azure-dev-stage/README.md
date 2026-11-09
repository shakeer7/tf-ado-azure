# Terraform Azure Non-Production Repository (`dev` & `stage`)

This repository manages **Dev** and **Staging** environments for Azure infrastructure, tailored for **Azure Free Tier accounts (single subscription)** with **Open Policy Agent (OPA)** policy enforcement and **Azure DevOps CI/CD**.

---

## 📁 Repository Structure

```text
tf-azure-dev-stage/
├── dev/                     # Dev environment configuration
│   ├── backend.tf           # Remote state backend
│   ├── main.tf              # Dev infrastructure composition
│   ├── outputs.tf           # Output declarations
│   ├── provider.tf          # Provider constraints (v5.13+)
│   ├── terraform.tfvars     # Dev variable inputs
│   └── variables.tf         # Input variable schemas
├── stage/                   # Staging environment configuration
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   └── variables.tf
├── modules/                 # Reusable Terraform modules
│   ├── aks/                 # AKS cluster with auto TLS SSH keys
│   ├── keyvault/            # Azure Key Vault with RBAC
│   └── ServicePrincipal/    # Azure AD App & SPN management
├── policy/                  # Open Policy Agent (OPA) Guardrails
│   ├── terraform.rego       # Rego security & Free Tier quota rules
│   └── evaluate-policy.sh   # OPA test execution script
├── pipelines/               # Azure DevOps YAML Pipelines
│   ├── azure-pipelines.yaml # Multi-stage CI/CD with OPA gate
│   └── destroy-pipeline.yaml# Teardown pipeline
└── scripts/
    ├── init-backend.sh      # Bash script to create remote state storage
    └── init-backend.ps1     # PowerShell backend setup
```

---

## 🛡️ OPA Policy Enforcement (Shift-Left Guardrails)

Before Terraform executes `apply`, the pipeline automatically converts `tfplan.binary` to JSON and validates it against [`policy/terraform.rego`](policy/terraform.rego). The pipeline halts if any of these rules fail:

1. **Approved Regions Only**: Resources must deploy only to approved regions (e.g. `canadacentral`, `eastus`) to stay within subscription location policies.
2. **Free Account VM Limits**: AKS node pools are restricted to approved lightweight SKUs (`Standard_B2s`, `Standard_DS2_v2`, etc.) to prevent high billing or depleting regional vCPU quotas (4 vCPUs max on free subscriptions).
3. **Max Node Pool Limit**: Max node count is capped at 2 nodes per cluster.
4. **Key Vault RBAC**: Requires `rbac_authorization_enabled = true`.
5. **No Purge Protection**: Prevents hard locks on temporary Key Vault resources during free trial experimentation.
6. **Mandatory Governance Tags**: Enforces `Environment`, `ManagedBy`, and `Project` tags.

---

## 🚀 Azure DevOps Setup

1. **Create Repository**: Push this directory to your Azure DevOps project as `tf-azure-dev-stage`.
2. **Service Connection**: Create an ARM Service Connection named `Azure-Service-Connection`.
3. **Variable Group**: Create a variable group `terraform-azure-secrets` if you wish to override storage account names or credentials.
4. **Environment Approvals**: In Azure DevOps under **Pipelines > Environments**, add approval checks on the `stage` environment for manual promotion approval.

