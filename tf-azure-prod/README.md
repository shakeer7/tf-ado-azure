<<<<<<< HEAD
# Introduction 
TODO: Give a short introduction of your project. Let this section explain the objectives or the motivation behind this project. 

# Getting Started
TODO: Guide users through getting your code up and running on their own system. In this section you can talk about:
1.	Installation process
2.	Software dependencies
3.	Latest releases
4.	API references

# Build and Test
TODO: Describe and show how to build your code and run the tests. 

# Contribute
TODO: Explain how other users and developers can contribute to make your code better. 

If you want to learn more about creating good readme files then refer the following [guidelines](https://docs.microsoft.com/en-us/azure/devops/repos/git/create-a-readme?view=azure-devops). You can also seek inspiration from the below readme files:
- [ASP.NET Core](https://github.com/aspnet/Home)
- [Visual Studio Code](https://github.com/Microsoft/vscode)
- [Chakra Core](https://github.com/Microsoft/ChakraCore)
=======
# Terraform Azure Production Repository (`prod`)

This repository manages the **Production** infrastructure on Azure, specifically engineered for a **single-subscription Azure Free Tier / Standard account** with strict **Open Policy Agent (OPA)** security gates and **Azure DevOps CI/CD**.

---

## 📁 Repository Structure

```text
tf-azure-prod/
├── prod/                    # Production environment configuration
│   ├── backend.tf           # Remote state backend
│   ├── main.tf              # Production infrastructure composition
│   ├── outputs.tf           # Output declarations
│   ├── provider.tf          # Provider constraints (v5.13+)
│   ├── terraform.tfvars     # Prod variable inputs
│   └── variables.tf         # Input variable schemas
├── modules/                 # Reusable Terraform modules
│   ├── aks/                 # AKS cluster with auto TLS SSH keys
│   ├── keyvault/            # Azure Key Vault with RBAC
│   └── ServicePrincipal/    # Azure AD App & SPN management
├── policy/                  # Open Policy Agent (OPA) Guardrails
│   ├── terraform.rego       # Rego security & Free Tier quota rules
│   └── evaluate-policy.sh   # OPA test execution script
├── pipelines/               # Azure DevOps YAML Pipelines
│   ├── azure-pipelines.yaml # Multi-stage CI/CD with Plan -> OPA -> Manual Gate -> Apply
│   └── destroy-pipeline.yaml# Teardown pipeline with explicit confirmation parameter
└── scripts/
    ├── init-backend.sh      # Bash script to create remote state storage
    └── init-backend.ps1     # PowerShell backend setup
```

---

## 🛡️ Production OPA Policy Enforcement

Before any production resource is created or altered, the pipeline generates a plan binary, converts it to JSON, and runs [`policy/terraform.rego`](policy/terraform.rego):

1. **Production Tag Enforcement**: Every resource must have `Environment = "prod"` to prevent accidental cross-environment configuration.
2. **Approved Regions Only**: Resources must deploy only to approved regions (e.g. `canadacentral`, `eastus`) to stay within subscription location policies.
3. **Free Account VM Limits**: AKS node pools are restricted to approved lightweight SKUs (`Standard_B2s`, `Standard_DS2_v2`, etc.) to prevent high billing or depleting regional vCPU quotas (4 vCPUs max on free subscriptions).
4. **Max Node Pool Limit**: Max node count is capped at 2 nodes per cluster.
5. **Key Vault RBAC**: Requires `rbac_authorization_enabled = true`.
6. **Mandatory Governance Tags**: Enforces `Environment`, `ManagedBy`, and `Project` tags.

---

## 🚀 Azure DevOps Setup

1. **Create Repository**: Push this directory to your Azure DevOps project as `tf-azure-prod`.
2. **Service Connection**: Create an ARM Service Connection named `Azure-Service-Connection`.
3. **Environment Approvals**: In Azure DevOps under **Pipelines > Environments > prod**, configure an **Approvals and Checks** gate with required reviewers so production apply never executes without explicit human approval.
>>>>>>> 1a0a86b (Initial commit: Production Terraform configuration with OPA security gate and Azure DevOps pipelines)
