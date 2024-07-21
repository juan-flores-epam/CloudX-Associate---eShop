param location string
param environmentName string
// param keyVaultName string
// param appInsightsInstrumentationKey string

var abbrs = loadJsonContent('../../abbreviations.json')

var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${abbrs.insightsComponents}web-${resourceToken}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

// resource appInsightsInstrumentationKeySecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
//   parent: keyVault
//   name: appInsightsInstrumentationKey
//   properties: {
//     value: appInsights.properties.InstrumentationKey
//   }
// }

// resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
//   name: keyVaultName
// }

output ConnectionString string = appInsights.properties.ConnectionString
