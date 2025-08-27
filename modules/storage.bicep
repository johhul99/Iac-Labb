targetScope = 'resourceGroup'

param name string
param location string
param tags object = {}

resource sa 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  tags: tags
}
