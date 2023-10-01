## Example bicep snippets to deploy resources 
param location string
param appSKU string
param servicePlan string
param appName string

## Example NodeJS app Service Plan Resource
resource nodeJSappServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: njsExAppAppSPlan
  location: location
  sku: {
    name: appSKU
  }
  properties: {
    reserved: true
  }
  kind: 'app,linux'
}

## Example NodeJS app Service Resource
resource njsAppService 'Microsoft.Web/sites@2022-09-01' = {
  name: appName
  location: location
  properties: {
    httpsOnly: true
    serverFarmId: nodeJSappServicePlan.id
    siteConfig: {
      linuxFxVersion: 'NODE|18-lts'
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
    }
  }
}
