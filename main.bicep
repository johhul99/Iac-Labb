targetScope = 'resourceGroup'

@allowed(['dev','test','prod'])
param environment string

param location string = resourceGroup().location
param tags object
param storagePrefix string
param kvPrefix string
param aspPrefix string
param appPrefix string
param skuName string
param skuTier string
param secretName string
param enableProdAutoscale bool
param autoscaleMin int
param autoscaleMax int
param autoscaleDefaultCapacity int
param autoscalePrefix string
param cpuThresholdScaleOut int
param cpuThresholdScaleIn int
param durationMinutes int
param cooldownMinutes int

// === Storage ===
module storage './modules/storage.bicep' = {
  name: 'storage-${environment}'
  params: {
    storagePrefix: storagePrefix
    location: location
    tags: tags
  }
}

module appsvc './modules/appservice.bicep' = {
  name: 'appsvc-${environment}'
  params: {
    aspPrefix: aspPrefix
    appPrefix: appPrefix
    location: location
    skuName: skuName
    skuTier: skuTier
    tags: tags
  }
}

module kv './modules/keyvault.bicep' = {
  name: 'kv-${environment}'
  params: {
    kvPrefix: kvPrefix
    location: location
    webAppPrincipalId: appsvc.outputs.principalId
    tags: tags
  }
}

module appsettings './modules/appsettings.bicep' = {
  name: 'appsettings-${environment}'
  params: {
    appName: appsvc.outputs.appNameOut
    vaultUri: kv.outputs.vaultUri
    secretName: secretName
  }
}

module autoscale './modules/autoscale.bicep' = if (environment == 'prod' && enableProdAutoscale) {
  name: 'autoscale-${environment}'
  params: {
    autoscalePrefix: autoscalePrefix
    targetResourceId: appsvc.outputs.planId
    minCapacity: autoscaleMin
    maxCapacity: autoscaleMax
    defaultCapacity: autoscaleDefaultCapacity
    cpuThresholdScaleOut: cpuThresholdScaleOut
    cpuThresholdScaleIn: cpuThresholdScaleIn
    durationMinutes: durationMinutes
    cooldownMinutes: cooldownMinutes
    location: location
    tags: tags
  }
}

output webAppUrl string = 'https://${appsvc.outputs.appNameOut}.azurewebsites.net'
