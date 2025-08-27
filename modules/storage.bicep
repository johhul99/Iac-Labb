targetScope = 'resourceGroup'

param storagePrefix string
param location string
param tags object = {}

var prefixClean = toLower(replace(storagePrefix, '-', ''))
var rawStg = '${prefixClean}${uniqueString(resourceGroup().id)}'
var storageName = substring(rawStg, 0, min(24, length(rawStg)))

resource stg 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  tags: tags
}

output storageName string = storageName
