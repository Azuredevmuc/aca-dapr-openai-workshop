targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

@description('The name of the container apps environment')
param containerAppsEnvironmentName string

@description('Name of the Dapr Secret Store component')
param daprComponentName string

@description('The name of the key vault')
param vaultName string

@description('The client id of the managed identity')
param managedIdentityClientId string

// ------------------
//    RESOURCES
// ------------------

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2023-11-02-preview' existing = {
  name: containerAppsEnvironmentName

  resource daprComponent 'daprComponents@2023-11-02-preview' = {
    name: daprComponentName
    properties: {
      componentType: 'secretstores.azure.keyvault'
      ignoreErrors: false
      version: 'v1'
      initTimeout: '5s'
      metadata: [
        {
          name: 'vaultName'
          value: vaultName
        }
        {
          name: 'azureClientId'
          value: managedIdentityClientId
        }
      ]
      scopes:[
        'summarizer-requests-processor'
      ]
    }
  }
}

output daprSecretStoreName string = containerAppsEnvironment::daprComponent.name
