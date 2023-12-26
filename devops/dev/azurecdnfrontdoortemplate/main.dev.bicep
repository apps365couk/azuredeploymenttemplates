param cdnName string
param changeMe string

// Azure CDN Front Door
resource frontDoorProfile 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: cdnName
  location: 'Global'
  sku:{
    name: 'Standard_AzureFrontDoor'
  }
  properties: {
    originResponseTimeoutSeconds: 60
  }
}

resource frontDoorEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2021-06-01' = {
  parent: frontDoorProfile
  name: 'afd-${uniqueString(resourceGroup().id)}'
  location: 'Global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource frontDoorOriginGroup 'Microsoft.Cdn/profiles/originGroups@2021-06-01' = {
  name: 'default-origin-group'
  parent: frontDoorProfile
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Http'
      probeIntervalInSeconds: 100
    }
    sessionAffinityState: 'Disabled'
  }
}

resource frontDoorOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2021-06-01' = {
  parent: frontDoorOriginGroup
  name: 'default-origin'
  properties: {
    hostName: changeMe
    httpPort: 80
    httpsPort: 443
    originHostHeader: changeMe
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    enforceCertificateNameCheck: true
  }
}

resource frontDoorRoute 'Microsoft.Cdn/profiles/afdEndpoints/routes@2021-06-01' = {
  parent: frontDoorEndpoint
  name: 'default-route'
  properties: {
    customDomains: []
    originGroup: {
      id: frontDoorOriginGroup.id
    }
    ruleSets: []
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'MatchRequest'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    enabledState: 'Enabled'
  }
}
