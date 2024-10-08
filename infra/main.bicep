targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string


@minLength(1)
@description('Secondary location for all resources')
param locationSecondary string = 'eastus'

// Optional parameters to override the default azd resource naming conventions. Update the main.parameters.json file to provide values. e.g.,:
// "resourceGroupName": {
//      "value": "myGroupName"
// }
param resourceGroupName string = ''
param webServiceName string = ''
// param webServiceNameSecondary string = ''
param catalogDatabaseName string = 'catalogDatabase'
param catalogDatabaseServerName string = ''
param identityDatabaseName string = 'identityDatabase'
param identityDatabaseServerName string = ''
param appServicePlanName string = ''
// param appServicePlanNameSecondary string = ''
param keyVaultName string = ''

@description('Id of the user or app to assign application roles')
param principalId string = ''

@secure()
@description('SQL Server administrator password')
param sqlAdminPassword string

@secure()
@description('Application user password')
param appUserPassword string

var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
// var resourceTokenSecondary = toLower(uniqueString(subscription().id, environmentName, locationSecondary))
// var storageAccountName = '${abbrs.storageStorageAccounts}${resourceToken}'
var tags = { 'azd-env-name': environmentName }

// Organize resources in a resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.resourcesResourceGroups}${environmentName}'
  location: location
  tags: tags
}

// The application frontend
// module web './core/host/appservice.bicep' = {
//   name: 'web'
//   scope: rg
//   params: {
//     name: !empty(webServiceName) ? webServiceName : '${abbrs.webSitesAppService}web-${resourceToken}'
//     location: location
//     appServicePlanId: appServicePlan.outputs.id
//     keyVaultName: keyVault.outputs.name
//     runtimeName: 'dotnetcore'
//     runtimeVersion: '8.0'
//     tags: union(tags, { 'azd-service-name': 'web' })
//     appSettings: {
//       AZURE_SQL_CATALOG_CONNECTION_STRING_KEY: 'AZURE-SQL-CATALOG-CONNECTION-STRING'
//       AZURE_SQL_IDENTITY_CONNECTION_STRING_KEY: 'AZURE-SQL-IDENTITY-CONNECTION-STRING'
//       AZURE_KEY_VAULT_ENDPOINT: keyVault.outputs.endpoint
//       appFunctions__url: 'https://test-app-jcfs-cloudx.azurewebsites.net/api/'
//       appFunctions__reserverEndpointName: 'OrderItemsReserver'
//       appFunctions__deliveryServiceFuntionAppUrl: 'https://delivery-app-jcfs-cloudx.azurewebsites.net/api/'
//       appFunctions__deliveryServiceEndpointName: 'OrderDeliveryFunction'
//     }
//   }
// }

module web './core/host/appservice.bicep' = {
  name: 'web'
  scope: rg
  params: {
    name: !empty(webServiceName) ? webServiceName : '${abbrs.webSitesAppService}web-${resourceToken}'
    location: location
    appServicePlanId: appServicePlan.outputs.id
    keyVaultName: keyVault.outputs.name
    runtimeName: 'DOCKER'
    runtimeVersion: 'acrcloudxjcfs.azurecr.io/eshopwebmvc:latest'
    tags: union(tags, { 'azd-service-name': 'web' })
    appSettings: {
      DOCKER_REGISTRY_SERVER_URL: 'acrcloudxjcfs.azurecr.io'
      DOCKER_REGISTRY_SERVER_USERNAME: 'acrcloudxjcfs'
      DOCKER_REGISTRY_SERVER_PASSWORD: 'J6Yubs3slc76USFhwKpfpjKTiflF59vXU7F16Hbwwz+ACRDYNTm/'
      AZURE_SQL_CATALOG_CONNECTION_STRING_KEY: 'AZURE-SQL-CATALOG-CONNECTION-STRING'
      AZURE_SQL_IDENTITY_CONNECTION_STRING_KEY: 'AZURE-SQL-IDENTITY-CONNECTION-STRING'
      AZURE_KEY_VAULT_ENDPOINT: keyVault.outputs.endpoint
      ASPNETCORE_URLS: 'http://*:8080'
      WEBSITED_PORT: '8080'
      PORT: '8080'
      appFunctions__url: 'https://test-app-jcfs-cloudx.azurewebsites.net/api/'
      appFunctions__reserverEndpointName: 'OrderItemsReserver'
      appFunctions__deliveryServiceFuntionAppUrl: 'https://delivery-app-jcfs-cloudx.azurewebsites.net/api/'
      appFunctions__deliveryServiceEndpointName: 'OrderDeliveryFunction'
    }
  }
}

// The application frontend
// module web2 './core/host/appservice.bicep' = {
//   name: 'web2'
//   scope: rg
//   params: {
//     name: !empty(webServiceNameSecondary) ? webServiceNameSecondary : '${abbrs.webSitesAppService}web-${resourceTokenSecondary}'
//     location: locationSecondary
//     appServicePlanId: appServicePlan2.outputs.id
//     keyVaultName: keyVault.outputs.name
//     runtimeName: 'dotnetcore'
//     runtimeVersion: '8.0'
//     tags: union(tags, { 'azd-service-name': 'web2' })
//     appSettings: {
//       AZURE_SQL_CATALOG_CONNECTION_STRING_KEY: 'AZURE-SQL-CATALOG-CONNECTION-STRING'
//       AZURE_SQL_IDENTITY_CONNECTION_STRING_KEY: 'AZURE-SQL-IDENTITY-CONNECTION-STRING'
//       AZURE_KEY_VAULT_ENDPOINT: keyVault.outputs.endpoint
//       APPLICATIONINSIGHTS_CONNECTION_STRING: appInsights.outputs.ConnectionString
//       appFunctions__url: 'https://test-app-jcfs-cloudx.azurewebsites.net/api/OrderItemsReserver?'
//       appFunctions__reserverEndpointName: 'OrderItemsReserver'
//     }
//   }
// }

// module api './core/host/appservice.bicep' = {
//   name: 'api'
//   scope: rg
//   params: {
//     name: '${abbrs.webSitesAppService}api-${resourceToken}'
//     location: location
//     appServicePlanId: appServicePlan.outputs.id
//     keyVaultName: keyVault.outputs.name
//     runtimeName: 'dotnetcore'
//     runtimeVersion: '8.0'
//     tags: union(tags, { 'azd-service-name': 'api' })
//     appSettings: {
//       AZURE_SQL_CATALOG_CONNECTION_STRING_KEY: 'AZURE-SQL-CATALOG-CONNECTION-STRING'
//       AZURE_SQL_IDENTITY_CONNECTION_STRING_KEY: 'AZURE-SQL-IDENTITY-CONNECTION-STRING'
//       AZURE_KEY_VAULT_ENDPOINT: keyVault.outputs.endpoint
//       APPLICATIONINSIGHTS_CONNECTION_STRING: appInsights.outputs.ConnectionString
//     }
//     allowedOrigins: [web.outputs.uri, web.outputs.uri]
//   }
// }

module api './core/host/appservice.bicep' = {
  name: 'api'
  scope: rg
  params: {
    name: '${abbrs.webSitesAppService}api-${resourceToken}'
    location: location
    appServicePlanId: appServicePlan.outputs.id
    keyVaultName: keyVault.outputs.name
    runtimeName: 'DOCKER'
    runtimeVersion: 'acrcloudxjcfs.azurecr.io/eshoppublicapi:latest'
    tags: union(tags, { 'azd-service-name': 'api' })
    appSettings: {
      DOCKER_REGISTRY_SERVER_URL: 'acrcloudxjcfs.azurecr.io'
      DOCKER_REGISTRY_SERVER_USERNAME: 'acrcloudxjcfs'
      DOCKER_REGISTRY_SERVER_PASSWORD: 'J6Yubs3slc76USFhwKpfpjKTiflF59vXU7F16Hbwwz+ACRDYNTm/'
      ASPNETCORE_URLS: 'http://*:8080'
      WEBSITED_PORT: '8080'
      PORT: '8080'
      AZURE_SQL_CATALOG_CONNECTION_STRING_KEY: 'AZURE-SQL-CATALOG-CONNECTION-STRING'
      AZURE_SQL_IDENTITY_CONNECTION_STRING_KEY: 'AZURE-SQL-IDENTITY-CONNECTION-STRING'
      AZURE_KEY_VAULT_ENDPOINT: keyVault.outputs.endpoint
      APPLICATIONINSIGHTS_CONNECTION_STRING: appInsights.outputs.ConnectionString
    }
    allowedOrigins: [web.outputs.uri]
  }
}

module apiKeyVaultAccess './core/security/keyvault-access.bicep' = {
  name: 'api-keyvault-access'
  scope: rg
  params: {
    keyVaultName: keyVault.outputs.name
    principalId: web.outputs.identityPrincipalId
  }
}

// module apiKeyVaultAccessSecondary './core/security/keyvault-access.bicep' = {
//   name: 'api-keyvault-access-secondary'
//   scope: rg
//   params: {
//     keyVaultName: keyVault.outputs.name
//     principalId: web2.outputs.identityPrincipalId
//   }
// }

module webApiKeyVaultAccess './core/security/keyvault-access.bicep' = {
  name: 'web-api-keyvault-access'
  scope: rg
  params: {
    keyVaultName: keyVault.outputs.name
    principalId: api.outputs.identityPrincipalId
  }
}

// The application database: Catalog
module catalogDb './core/database/sqlserver/sqlserver.bicep' = {
  name: 'sql-catalog'
  scope: rg
  params: {
    name: !empty(catalogDatabaseServerName) ? catalogDatabaseServerName : '${abbrs.sqlServers}catalog-${resourceToken}'
    databaseName: catalogDatabaseName
    location: location
    tags: tags
    sqlAdminPassword: sqlAdminPassword
    appUserPassword: appUserPassword
    keyVaultName: keyVault.outputs.name
    connectionStringKey: 'AZURE-SQL-CATALOG-CONNECTION-STRING'
  }
}

// The application database: Identity
module identityDb './core/database/sqlserver/sqlserver.bicep' = {
  name: 'sql-identity'
  scope: rg
  params: {
    name: !empty(identityDatabaseServerName) ? identityDatabaseServerName : '${abbrs.sqlServers}identity-${resourceToken}'
    databaseName: identityDatabaseName
    location: location
    tags: tags
    sqlAdminPassword: sqlAdminPassword
    appUserPassword: appUserPassword
    keyVaultName: keyVault.outputs.name
    connectionStringKey: 'AZURE-SQL-IDENTITY-CONNECTION-STRING'
  }
}

// Store secrets in a keyvault
module keyVault './core/security/keyvault.bicep' = {
  name: 'keyvault'
  scope: rg
  params: {
    name: !empty(keyVaultName) ? keyVaultName : '${abbrs.keyVaultVaults}${resourceToken}'
    location: location
    tags: tags
    principalId: principalId
  }
}

// Create an App Service Plan to group applications under the same payment plan and SKU
module appServicePlan './core/host/appserviceplan.bicep' = {
  name: 'appserviceplan'
  scope: rg
  params: {
    name: !empty(appServicePlanName) ? appServicePlanName : '${abbrs.webServerFarms}${resourceToken}'
    location: location
    tags: tags
    sku: {
      name: 'P0V3'
    }
  }
}

// module appServicePlan2 './core/host/appserviceplan.bicep' = {
//   name: 'appserviceplan2'
//   scope: rg
//   params: {
//     name: !empty(appServicePlanNameSecondary) ? appServicePlanNameSecondary : '${abbrs.webServerFarms}${resourceTokenSecondary}'
//     location: locationSecondary
//     tags: tags
//     sku: {
//       name: 'B1'
//     }
//   }
// }

// module trafficManager './core/network/trafficManager.bicep' = {
//   name: 'trafficManagerJCFS'
//   scope: rg
//   params: {
//     endpoints: [
//       {
//         name: 'endpointCentralUs'
//         type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
//         properties: {
//           endpointStatus: 'Enabled'
//           targetResourceId: web.outputs.id
//         }
//       }
//       {
//         name: 'endpointEastlUs'
//         type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
//         properties: {
//           endpointStatus: 'Enabled'
//           targetResourceId: web2.outputs.id
//         }
//       }
//     ]
//   }
// }

module appInsights 'core/monitoring/applicationInsights.bicep' = {
  name: 'appInsights'
  scope: rg
  params: {
    environmentName: environmentName
    location: location
    // appInsightsInstrumentationKey: 'AZURE_APPLICATION_INSIGHTS_INSTRUMENTATION_KEY'
    // keyVaultName: keyVault.outputs.name
  }
}

// module storageAccount './core/storage/storage-account.bicep' = {
//   scope: rg
//   name: 'storageaccount'
//   params: {
//     name: storageAccountName
//     location: location
//     tags: tags
//   }
// }



// Data outputs
output AZURE_SQL_CATALOG_CONNECTION_STRING_KEY string = catalogDb.outputs.connectionStringKey
output AZURE_SQL_IDENTITY_CONNECTION_STRING_KEY string = identityDb.outputs.connectionStringKey
output AZURE_SQL_CATALOG_DATABASE_NAME string = catalogDb.outputs.databaseName
output AZURE_SQL_IDENTITY_DATABASE_NAME string = identityDb.outputs.databaseName

// App outputs
output AZURE_LOCATION string = location
// output AZURE_LOCATION_SECONDARY string = locationSecondary
output AZURE_TENANT_ID string = tenant().tenantId
output AZURE_KEY_VAULT_ENDPOINT string = keyVault.outputs.endpoint
output AZURE_KEY_VAULT_NAME string = keyVault.outputs.name
// output AZURE_APPLICATION_INSIGHTS_INSTRUMENTATION_KEY string = appInsights.outputs.InstrumentationKey
