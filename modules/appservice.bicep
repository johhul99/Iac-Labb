targetScope = 'resourceGroup'

param location string
param appServicePlanName string
param appName string
param tags object = {}
param skuName string
param skuTier string

resource plan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    tier: skuTier
    capacity: 1
  }
  tags: tags
}

resource app 'Microsoft.Web/sites@2024-11-01' = {
  name: appName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
  }
  tags: tags
}

output webAppUrl string = 'https://${app.name}.azurewebsites.net'
output planId string = plan.id
output principalId string = app.identity.principalId
