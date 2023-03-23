@description('The name of the Managed Cluster resource.')
param clusterName string = 'aks-alt-demo-small'

@description('The name of the Managed Cluster resource.')
param clusterNameBeefy string = 'aks-alt-demo-beefy'

@description('The location of the Managed Cluster resource.')
param location string = resourceGroup().location

@description('Optional DNS prefix to use with hosted Kubernetes API server FQDN.')
param dnsPrefix string = 'aks-alt-demo'

@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(50)
param agentCount int = 2

@description('The size of the Virtual Machine.')
param agentVMSize string = 'standard_d2s_v3' //2vCPU, 8GB RAM

@description('The size of the Virtual Machine.')
param agentVMSizeBeefy string = 'Standard_D8s_v3' //8vCPU, 32GB RAM

@description('User name for the Linux Virtual Machines.')
param linuxAdminUsername string = 'azureuser'

@description('Configure all linux machines with the SSH RSA public key string. Your key should include three parts, for example \'ssh-rsa AAAAB...snip...UcyupgH azureuser@linuxvm\'')
param sshRSAPublicKey string = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCdhXnsalq/Y7Id3WmpyE53t/pfXoBhqrbygZYfuPe1UKCFg/Aj2T2uE2Uck9A13vEzKRTqGsQTqKuqArxaLgefExeeXXTy8HarpSxO3d1jJ75iqYB9eSGO52PIl/gVSaZzW977xr9Kl+tPY4BdCDo51uswQ8N7TMmgHtzSijosIeXcJirVwieCZH9+2uxnQQ52rCkv2+ejdMSV5O2ah7MP+gQ4msdYSY2L06Nw6t04BI0QBWJ8YKEVfrz17HGuyE2+ECgIRyFu2ekLP65RbKCl/ybJme3FmPYTfQaZVFaaarMdoauv0YmHNrVdNDuImozQFDxMLeiHt6TJBW32/1tIwA/Rj96b38rDQIp8osAJypyaCJhcsHaF8dDPoGvlBeLt0dBRcXOmAplz64G9C3SHK9w5ST0wmmfMNkVTYYWDtxuBypwg6Y7S3ES5Vtcuoks05xYPTjCMskernva32JKVosx/fwGI/WM9zbmYnnp/HsjjG21FiN9hsSSwgr/pBp2gXCek4rXSyBljo00KTR7mPnhyx5NmbbEWJ03s6T4lSojRk9cSr0szLD5exE05/xWHR9CoHDogKaOiK+axEp6c0nGOAwEP5p1Wsk6L9DxJE1DW/0tTAtK+yQKVfHaCUvtMJtJfbfCuzuI6tHoncETF0rQ+k6aquJHn80RstmxauQ== azureuser@linuxvm'

resource aks 'Microsoft.ContainerService/managedClusters@2022-05-02-preview' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
  }
}

resource aksBeefy 'Microsoft.ContainerService/managedClusters@2022-05-02-preview' = {
  name: clusterNameBeefy
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSizeBeefy
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
  }
}

// output controlPlaneFQDN string = aks.properties.fqdn
