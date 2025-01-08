//param location string = resourceGroup().location

@description('Username for the Virtual Machine')
param mladminid string = 'mladmin'

@description('Password for the Virtual Machine.')
@secure()
param mladminpwd string

@description('Set Vms Time Zone to GMT.')
param timezone string = 'GMT Standard Time'

@description('Site Virtual Machine Name')
param vmName string = 'mlvm'

@description('Windows OS version')
param windowsOSVersion string = '2016-datacenter-gensecond'


//Reference existing ResourceGroup
resource mlrg 'Microsoft.Resources/resourceGroups@2024-07-01' existing = {
  name:'MichaelLauLab'
  scope:subscription('2433ca04-f4eb-4040-a5ee-0dac9b2c7e30')
}

  //Reference existing vNet
  resource mlvnet 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
    name:'LabVM1-vnet'
  }
 
 output mlvnetname object = mlvnet.properties.addressSpace

//Reference existing vNet
resource mlsubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' existing = {
  parent:mlvnet
  name:'default'
  
}

output mlsubnet object = mlsubnet




//Create a network interface in the desired subnet
@description('Create network interface bound to existing vnet and subnet')
resource mlvmnic 'Microsoft.Network/networkInterfaces@2019-11-01' =  {
  name: '${vmName}-nic'
  location: resourceGroup().location
    properties: {
      ipConfigurations: [{
        name: 'ipConfig1'
          properties: {
          privateIPAllocationMethod: 'Dynamic'
          privateIPAddressVersion:'IPv4'
//          publicIPAddress: {
//            id: ix_PublicIP.id
//          }
            subnet: {
            id: mlsubnet.id
                    }         
                      }
                        }]
              }   
}

//Create vm 
@description('Create Virtual Machine.')
resource mlvm 'Microsoft.Compute/virtualMachines@2019-07-01' = {
  name: vmName
  location: resourceGroup().location
    tags: {
      displayName: vmName
      }
    properties: {
      hardwareProfile: {
        vmSize: 'Standard_D2s_v3'
        }
        osProfile: {
        computerName: vmName
        adminUsername: mladminid
        adminPassword: mladminpwd
        windowsConfiguration:{
          timeZone:timezone
        } 
        }
      storageProfile: {
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: windowsOSVersion
          version: '14393.6252.230905'
          }
        osDisk: {
          name: vmName
          caching: 'ReadWrite'
          createOption: 'FromImage'
          }
        }
    
//        dataDisks: [for addisk in range(0, dataDisksCount): {
//          name: '${sitevmName}-DataDisk${addisk}'
//          diskSizeGB: dataDiskSize
//          lun: addisk
//          createOption: 'Empty'
//          managedDisk: {
//          storageAccountType: 'Standard_LRS'
//         }
//         }]
//         }
        networkProfile: {
          networkInterfaces: [{
            id: mlvmnic.id
            }]
          }
          
//        diagnosticsProfile: {
//          bootDiagnostics: {
//          enabled: true
//            storageUri: Bootdiagnostic.properties.primaryEndpoints.blob
//                 }
//                }
//              }
        }}
