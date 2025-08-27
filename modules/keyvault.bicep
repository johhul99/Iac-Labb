targetScope = 'resourceGroup'

param location string
param webAppPrincipalId string
param tags object = {}
param kvName string

resource kv 'Microsoft.KeyVault/vaults@2024-11-01' = {
  name: kvName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: webAppPrincipalId
        permissions: {
          secrets: [ 'get', 'list' ]
        }
      }
    ]
  }
  tags: tags
}

output vaultUri string = kv.properties.vaultUri
