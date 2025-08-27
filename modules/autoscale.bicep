targetScope = 'resourceGroup'

param autoscaleName string
param targetResourceId string

@minValue(1)
param min int

@minValue(1)
param max int

@minValue(1)
param defaultCapacity int

param location string
param tags object = {}

resource as 'Microsoft.Insights/autoscalesettings@2022-10-01' = {
  name: autoscaleName
  location: location
  tags: tags
  properties: {
    name: autoscaleName
    enabled: true
    targetResourceUri: targetResourceId
    profiles: [
      {
        name: 'default'
        capacity: {
          minimum: string(min)
          maximum: string(max)
          default: string(defaultCapacity)
        }
        rules: []
      }
    ]
  }
}
