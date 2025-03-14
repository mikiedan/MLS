#Get MAC address of the adpater that is currently connected.
Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Select-Object -ExpandProperty MacAddress

#Get the hostname.
$gethost = (Hostname)
#Define the domain.
$Domain = 'MLCORP.NET'
#Define the OU path machine is going to be added to.
$OUPath = 'OU=Bitlocker,OU=TestOU-1,DC=MLCORP,DC=NET'

#Add the machine to the domain.
Add-Computer -ComputerName $gethost -DomainName $Domain -Restart -OUPath $OUPath -Credential 'mlitservicedesk@microland.com'