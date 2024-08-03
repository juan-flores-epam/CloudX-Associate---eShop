metadata description = 'Creates an Azure Function in an existing Azure App Service plan.'
param name string
param location string = resourceGroup().location
param tags object = {}

// Reference Properties
param appServicePlanId string
param keyVaultName string = ''
param managedIdentity bool = !empty(keyVaultName)
param storageAccountName string
param appInsightsConnectionString string

var functionAppName = '${name}-functions'

// Runtime Properties
@allowed([
  'dotnet', 'dotnetcore', 'dotnet-isolated', 'node', 'python', 'java', 'powershell', 'custom'
])
param runtimeName string


// Function Settings
@allowed([
  '~4', '~3', '~2', '~1'
])
param extensionVersion string = '~4'

// Microsoft.Web/sites Properties
param kind string = 'functionapp,linux'

@secure()
param appSettings object = {}
param use32BitWorkerProcess bool = false

module functions 'appservice.bicep' = {
  name: '${name}-functions'
  params: {
    name: name
    location: location
    tags: tags
    appServicePlanId: appServicePlanId
    appSettings: union(appSettings, {
        AzureWebJobsStorage: 'DefaultEndpointsProtocol=https;AccountName=${storage.name};AccountKey=${storage.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: 'DefaultEndpointsProtocol=https;AccountName=${storage.name};AccountKey=${storage.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        WEBSITE_CONTENTSHARE: toLower('${name}')
        FUNCTIONS_EXTENSION_VERSION: extensionVersion
        FUNCTIONS_WORKER_RUNTIME: runtimeName
      })
    keyVaultName: keyVaultName
    kind: kind
    managedIdentity: managedIdentity
    use32BitWorkerProcess: use32BitWorkerProcess
    runtimeName: 'dotnetcore'
    runtimeVersion: '8.0'
  }
}

resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  properties: {
    reserved: true
    serverFarmId: appServicePlanId
    siteConfig: {
      linuxFxVersion: 'node|14'
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionAppName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
      ]
    }
  }
}

resource storage 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName
}

output identityPrincipalId string = managedIdentity ? functions.outputs.identityPrincipalId : ''
output name string = functions.outputs.name
output uri string = functions.outputs.uri
