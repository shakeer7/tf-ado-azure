# PowerShell script to initialize remote backend for Azure Free Tier account
$ErrorActionPreference = "Stop"

$ResourceGroupName = "rg-tf-state"
$Location = "canadacentral"
$StorageAccountName = "tfstateazfree01"
$ContainerName = "tfstate"

Write-Host "Creating Resource Group: $ResourceGroupName in $Location..."
az group create --name $ResourceGroupName --location $Location --tags Environment=management ManagedBy=Terraform Project=tf-ado

Write-Host "Creating Storage Account: $StorageAccountName..."
az storage account create `
  --name $StorageAccountName `
  --resource-group $ResourceGroupName `
  --location $Location `
  --sku Standard_LRS `
  --encryption-services blob `
  --allow-blob-public-access false `
  --min-tls-version TLS1_2

Write-Host "Creating Blob Container: $ContainerName..."
az storage container create `
  --name $ContainerName `
  --account-name $StorageAccountName `
  --auth-mode login

Write-Host "Backend initialized successfully!" -ForegroundColor Green

