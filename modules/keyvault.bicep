targetScope = 'resourceGroup'

param kvPrefix string
param location string
param webAppPrincipalId string
param tags object = {}

var rawKv = toLower('${kvPrefix}${uniqueString(resourceGroup().id)}')
var kvName = substring(rawKv, 0, min(24, length(rawKv)))

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
output kvNameOut string = kvName

