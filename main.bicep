targetScope = 'resourceGroup'

@allowed(['dev','test','prod'])
param environment string
param location string = resourceGroup().location
param appServicePlanName string
param appName string
param storageAccountName string
param secretName string
param skuName string
param skuTier string
param kvName string
param tags object

module storage './modules/storage.bicep' = {
  name: 'stg-${environment}'
  params: {
    name: storageAccountName   
    location: location
    tags: tags
  }
}

module appsvc './modules/appservice.bicep' = {
  name: 'appsvc-${environment}'
  params: {
    location: location
    appServicePlanName: appServicePlanName
    appName: appName
    skuName: skuName
    skuTier: skuTier
    tags: tags
  }
}
module kv './modules/keyvault.bicep' = {
  name: 'kv-${environment}'
  params: {
    location: location
    webAppPrincipalId: appsvc.outputs.principalId
    kvName: kvName
    tags: tags
  }
}

module appSettings './modules/appsettings.bicep' = {
  name: 'appsettings-${environment}'
  params: {
    appName: appName
    vaultUri: kv.outputs.vaultUri
    secretName: secretName 
  }
}

param enableProdAutoscale bool
param autoscaleMin int
param autoscaleMax int
param autoscaleDefaultCapacity int

module autoscale './modules/autoscale.bicep' = if (environment == 'prod' && enableProdAutoscale) {
  name: 'autoscale-${environment}'
  params: {
    autoscaleName: 'auto-${appServicePlanName}'
    targetResourceId: appsvc.outputs.planId
    min: autoscaleMin
    max: autoscaleMax
    defaultCapacity: autoscaleDefaultCapacity
    location: location
    tags: tags
  }
}

output webAppUrl string = appsvc.outputs.webAppUrl
