targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

@description('Name of the Dapr Output Binding component')
param daprComponentName string

@description('Name of the Azure Container Apps environment')
param containerAppsEnvironmentName string

@description('SMTP Host')
@secure()
param smtpHost string

@description('SMTP Port')
param smtpPort int

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2023-11-02-preview' existing = {
  name: containerAppsEnvironmentName

  resource daprComponent 'daprComponents@2023-11-02-preview' = {
    name: daprComponentName
    properties: {
      componentType: 'bindings.smtp'
      version: 'v1'
      metadata: [
        {
          name: 'emailFrom'
          value: 'noreply@summarize.io'
        }
        {
          name: 'host'
          value: smtpHost
        }
        {
          name: 'port'
          value: string(smtpPort)
        }
      ]
      scopes:[
        'summarizer-requests-api'
      ]
    }
  }
}

output daprEmailOutputBindingName string = containerAppsEnvironment::daprComponent.name
