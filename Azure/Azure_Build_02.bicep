


//Reference existing ResourceGroup
resource mlrg 'Microsoft.Resources/resourceGroups@2024-07-01' existing = {
    name:'MichaelLauLab'
    scope:subscription('2433ca04-f4eb-4040-a5ee-0dac9b2c7e30')
  }

output mlrgname string = mlrg.name
  
  //Reference existing vNet
  resource mlvnet 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
   name:'LabVM1-vnet'
 }


//Reference existing vNet
resource mlsubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' existing = {
  parent:mlvnet
  name:'default'
  
}


output mlvnetname object = mlvnet.properties.addressSpace
output mlsubnetname object = mlsubnet.properties
