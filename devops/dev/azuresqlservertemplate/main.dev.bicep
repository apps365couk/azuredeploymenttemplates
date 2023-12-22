param location string

param sqlServerName string
param sqlDatabaseName string
param sqlServerLogin string
@secure()
param sqlServerPassword string

resource server 'Microsoft.Sql/servers@2021-11-01' = {
  name: sqlServerName
  location: location
  tags: {}
  properties: {
    version: '12.0'
    administratorLogin: sqlServerLogin
    administratorLoginPassword: sqlServerPassword
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }
}

resource database 'Microsoft.Sql/servers/databases@2021-11-01' = {
  parent: server
  name: sqlDatabaseName
  location: location
  tags: {}
  sku:{
    name: 'Basic'
    tier: 'Basic'
    capacity: 5
  }
  properties: {
    maxSizeBytes: 2147483648
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    sampleName: 'AdventureWorksLT'
    zoneRedundant: false
    readScale: 'Disabled'
  }
}

resource serverFirewallRule 'Microsoft.Sql/servers/firewallrules@2015-05-01-preview' = {
  parent: server
  name: 'AllowAllWindowsAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}
