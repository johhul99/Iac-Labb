targetScope = 'resourceGroup'

param autoscalePrefix string
param targetResourceId string

@minValue(1) 
param minCapacity int

@minValue(1) 
param maxCapacity int

@minValue(1) 
param defaultCapacity int

param cpuThresholdScaleOut int
param cpuThresholdScaleIn int
param durationMinutes int
param cooldownMinutes int
param location string
param tags object = {}

var rawAuto = toLower('${autoscalePrefix}${uniqueString(resourceGroup().id)}')
var autoscaleName = substring(rawAuto, 0, min(90, length(rawAuto)))

resource auto 'Microsoft.Insights/autoscalesettings@2022-10-01' = {
  name: autoscaleName
  location: location
  tags: tags
  properties: {
    name: autoscaleName
    enabled: true
    targetResourceUri: targetResourceId
    profiles: [
      {
        name: 'DefaultProfile'
        capacity: {
          minimum: '${minCapacity}'
          maximum: '${maxCapacity}'
          default: '${defaultCapacity}'
        }
        rules: [
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricNamespace: 'Microsoft.Web/serverfarms'
              metricResourceUri: targetResourceId 
              operator: 'GreaterThan'
              statistic: 'Average'
              threshold: cpuThresholdScaleOut
              timeAggregation: 'Average'
              timeGrain: 'PT1M'
              timeWindow: 'PT${durationMinutes}M'
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT${cooldownMinutes}M'
            }
          }
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricNamespace: 'Microsoft.Web/serverfarms'
              metricResourceUri: targetResourceId
              operator: 'LessThan'
              statistic: 'Average'
              threshold: cpuThresholdScaleIn
              timeAggregation: 'Average'
              timeGrain: 'PT1M'
              timeWindow: 'PT${durationMinutes}M'
            }
            scaleAction: {
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT${cooldownMinutes}M'
            }
          }
        ]
      }
    ]
  }
}

output autoscaleNameOut string = autoscaleName

