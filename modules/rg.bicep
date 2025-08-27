targetScope = 'subscription'

param rgPrefix string
param location string
param tags object = {}

var rgName = '${rgPrefix}${uniqueString(subscription().id)}'

resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: rgName
  location: location
  tags: tags
}

output rgNameOut string = rg.name

