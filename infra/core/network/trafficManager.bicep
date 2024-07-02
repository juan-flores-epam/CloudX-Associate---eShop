param endpoints array

resource trafficManager 'Microsoft.Network/trafficmanagerprofiles@2018-08-01' = {
  name: 'trafficManagerCloudx'
  location: 'global'
  properties: {
    profileStatus: 'Enabled'
    trafficRoutingMethod: 'Performance'
    monitorConfig: {
      protocol: 'HTTPS'
      port: 443
      path: '/'
      expectedStatusCodeRanges: [
        {
          min: 200
          max: 202
        }
        {
          min: 301
          max: 302
        }
      ]
    }
    dnsConfig: {
      relativeName: 'trafficManagercloudx'
      ttl: 30
    }
    endpoints: endpoints
  }
}
