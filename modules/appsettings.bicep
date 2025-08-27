targetScope = 'resourceGroup'

param appName string
param vaultUri string
param secretName string

resource app 'Microsoft.Web/sites@2024-11-01' existing = {
  name: appName
}

resource cfg 'Microsoft.Web/sites/config@2024-11-01' = {
  parent: app
  name: 'appsettings'
  properties: {
    DemoSecretFromKV: '@Microsoft.KeyVault(SecretUri=${vaultUri}secrets/${secretName}/)'
  }
}

