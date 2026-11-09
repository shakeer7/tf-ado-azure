#!/usr/bin/env bash
# Initialize remote backend for Azure Free Tier account
set -euo pipefail

RESOURCE_GROUP_NAME="rg-tf-state"
LOCATION="canadacentral"
STORAGE_ACCOUNT_NAME="tfstateazfree01"
CONTAINER_NAME="tfstate"

echo "Creating Resource Group: $RESOURCE_GROUP_NAME in $LOCATION..."
az group create --name "$RESOURCE_GROUP_NAME" --location "$LOCATION" --tags Environment=management ManagedBy=Terraform Project=tf-ado

echo "Creating Storage Account: $STORAGE_ACCOUNT_NAME..."
az storage account create \
  --name "$STORAGE_ACCOUNT_NAME" \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --encryption-services blob \
  --allow-blob-public-access false \
  --min-tls-version TLS1_2

echo "Creating Blob Container: $CONTAINER_NAME..."
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --auth-mode login

echo "Backend initialization complete! You can now run Terraform with remote state in $STORAGE_ACCOUNT_NAME/$CONTAINER_NAME."

