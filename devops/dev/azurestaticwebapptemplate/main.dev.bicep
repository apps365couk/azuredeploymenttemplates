param location string
param appName string
param staticAppSKU string

resource staticWebApp 'Microsoft.Web/staticSites@2022-09-01' = {
  name: '${appName}-staticwebapp'
  location: location
  properties: {
    buildProperties: {
      apiBuildCommand: 'string'
      apiLocation: 'api'
      appLocation: 'ui'
    }
  }
  sku: {
    name: staticAppSKU // Specify the desired SKU here, e.g., 'F1' for the Free Tier
  }
}

output staticWebAppUrl string = staticWebApp.properties.defaultHostname
