targetScope = 'resourceGroup'

param aspPrefix string
param appPrefix string
param location string
param skuName string
param skuTier string
param tags object = {}

var rawPlan = toLower('${aspPrefix}${uniqueString(resourceGroup().id)}')
var aspName = substring(rawPlan, 0, min(40, length(rawPlan)))
var rawApp = toLower('${appPrefix}${uniqueString(resourceGroup().id)}')
var appName = substring(rawApp, 0, min(60, length(rawApp)))

resource plan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: aspName
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

output planId string = plan.id
output principalId string = app.identity.principalId
output appNameOut string = app.name

