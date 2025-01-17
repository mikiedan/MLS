#Standard folder creation
$staging = @("staging1","staging2","staging3")
Foreach ($folder in $staging)
{
New-Item -ItemType Directory -Path "C:\Microland\$folder" -ErrorAction SilentlyContinue | Out-Null
}

#Variables
$lastthreex = 'XXX'
$lastthreey = 'yyy'
$lastthreez = 'zzz'
$myipx = 'xxx'
$myipy = 'yyy'
$myipz = 'zzz'

#From IP determins the name given to host based on Availability Zone 
$GetHost = (hostname)
$myip = (Test-Connection -ComputerName $GetHost -Count 1 | select -ExpandProperty IPV4Address).IPAddressToString
$myip1 = $myip.Split(".")[3]
Ipconfig | Out-File -FilePath C:\microland\ip.txt
$myip2 = Get-Content C:\Microland\ip.txt -TotalCount 10 | select -Last 1
$myip3 = $myip2.Split(".")[-1]
$myip4 = $myip.split(".")[2] 
$Subnet = @(1..128)
$domain = (Get-WmiObject Win32_ComputerSystem).Domain


#Refer to AWS migration spreadsheet for last 3 numbers of servername column D
If ($GetHost -like 'EC2*')
{
$lastthree = Read-Host -Prompt "Last 3 numbers of Server being built eg: 120 for RDS, 121 for Scom etc....."
}
else
{
Write-Host -F Green "Device already named"
}

#Hash Table 
$whatdomain = @{
'3' = @{'Acdns' = '10.201.3.11'
        'Ccdns' = '10.201.3.217'
          'ECM' = '\\C2ac00111\PackageSource\ECMClient\2211\PKI_net_install.cmd'
         'Scom' = '\\c2ac00111\PackageSource\All_package_files\MSFT_SCOM_AGENT_10\SCOMAgentInstall-ML.ps1'
        'dnfqn' = 'Appt.local'
      'hacname' = 'C2AC00'
      'hccname' = 'C2CC00' 
                        }           
                     
'4' = @{'Acdns' = '10.201.4.93'
        'Ccdns' = '10.201.4.254'
          'ECM' = '\\C1AC00111\PackageSource\ECMClient_2211\PKI_net_install.cmd'
         'Scom' = '\\C1ac00111\PackageSource\All Packages_files\MSFT_SCOM_AGENT_10\SCOMAgentInstall-ML.ps1'
        'dnfqn' = 'Test.local' 
      'hacname' = 'C1AC00'
      'hccname' = 'C1CC00'            
                        }
                        
'5' = @{'Acdns' = '10.201.5.30'
        'Ccdns' = '10.201.5.191' 
          'ECM' = '\\C3ac00111\PackageSource\ECMClient\2211\PKI_net_install.cmd'
         'Scom' = '\\c3ac00111\PackageSource\Packages\All Packages_files\MSFT_SCOM_AGENT_10\SCOMAgentInstall-ML.ps1'             
        'dnfqn' = 'Pret.local'
      'hacname' = 'C3AC00'
      'hccname' = 'C3CC00'  
                         }
                                              
'2' = @{'Acdns' = '10.201.2.109'
        'Ccdns' = '10.201.2.193'
          'ECM' = '\\C1ac00111\PackageSource\ECMClient\2211\PKI_net_install.cmd'
         'Scom' = '\\C1ac00111\PackageSource\ML\Scom\SCOMAgentInstallML.ps1'             
        'dnfqn' = 'dmzt.local'
      'hacname' = 'C1AC00'
      'hccname' = 'C1CC00'  
                        }
                }
                

$dm = $whatdomain 

#Define machine DNS servers based from Hash Table
#################################################################################################################             
$dmdns1 = $dm.$myip4.Acdns
$dmdns2 = $dm.$myip4.Ccdns
$dmdns3 = $dmdns1 +',' + $dmdns2
                

#Get machine's Availability Zone based on IP from Hash Table
#################################################################################################################             
If ($Subnet -contains $myip1 -and $myip3 -eq '128')
{
$azone = $dm.$myip4.hacname
}
else
{
$azone = $dm.$myip4.hccname
}


#Popultate Hash table for multiple machines if required
#################################################################################################################
$SRV1 = $lastthree
$IP1 = $myip1 #Paste IP

$naming = @{}
$naming.add($IP1,$SRV1)


if ($myip1 -eq $myip1)
{
$awsrename = $naming[$myip1]
}

#Will rename Host to $finalname
$finalname = $azone + $awsrename


#Check to see if machine has already been named to AWS Standard
If ($GetHost -like 'EC2*')
{
#Rename to correct Hostname
rename-computer -NewName $finalname
Shutdown /r
}
else
{
Write-Host -F Green  "Check to join a domain"
}

Start-Sleep -Seconds 30

if ($GetHost -match 'C[1-3]'-and (gwmi win32_computersystem).Domain -eq 'WORKGROUP')
{

        if ($myip4 -eq '3')
        {
        Write-Host -F Green "Machine not domain joined"
        $jdm = $dm.$myip4.dnfqn 
        }
        elseif ($myip4 -eq '4')
                {
        $jdm = $dm.$myip4.dnfqn  
        Write-Host -F Green "Machine not domain joined"
        }
        elseif ($myip4 -eq '5')
        {
        $jdm = $dm.$myip4.dnfqn  
        Write-Host -F Green "Machine not domain joined"
        }
        elseif ($myip4 -eq '2')
        {
        $jdm = $dm.$myip4.dnfqn  
        Write-Host -F Green "Machine not domain joined"
        }
      $if = Get-NetAdapter -Name * | where {$_.Status -eq "Up"} | select -ExpandProperty ifindex
       Set-DnsClientServerAddress -InterfaceIndex $if -ServerAddresses $dmdns3
        Add-Computer -DomainName $jdm -Restart -ErrorAction Stop -Credential "$jdm\svc-mlbuild"
}
else
{
$jdm = $dm.$myip4.dnfqn
if ($GetHost -match 'C[1-3]'-and (gwmi win32_computersystem).Domain -eq $jdm)
{
Write-Host -F Green "Machine already in" $jdm "Domain"
}
}

#####################################################################################################
#Stop Format gui appearing while formatting the additional disks.
Stop-Service -Name ShellHWDetection
Start-Sleep -Seconds 10

#Bring online additional disk if required
$offline = Get-Disk | Where partitionstyle -eq ‘raw’ 
if ($offline.Count -eq 0) {
    Write-Host 'All disks are online' -F Green
} else 
 {
     foreach ($disk in $offline) {
         $VolumeName = 'Data'
                    Write-Host "Bringing disk $($disk.Number) online..." 
            initialize-disk -Number $($disk.Number) -PartitionStyle GPT
                Start-Sleep 10   
                    $np = New-Partition -DiskNumber $($disk.Number) -AssignDriveLetter -UseMaximumSize  -GptType "{ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}"  
                      format-volume $np.DriveLetter -filesystem NTFS -newfilesystemlabel $VolumeName -Force
                            Write-Host "Formatting disk $($disk.Number)..."
 }
}
#####################################################################################################
#Install ECM client
$jdm = $dm.$myip4.ECM

$ecmstatus =  Get-service -DisplayName 'SMS Agent Host' -ErrorAction Ignore | select -ExpandProperty Status

if ($ecmstatus -eq 'Running')
{ 
Write-Host -F Green "ECM client successfully installed" 
}
else
{
if ( $myip4 -eq '3' )
    { 
    start-process $jdm -verb runas
    Write-Host -F Green "ECM client install for Dev"
    Start-sleep 300
    Shutdown /r
    }
    elseif ($myip4 -eq '4') 
    {
    start-process $jdm -verb runas
    Write-Host -F Green "ECM client install for Test"
    Start-sleep 300
    Shutdown /r
    }
    elseif  ($myip4 -eq '5') 
    {
    start-process $jdm -verb runas
    Write-Host -F Green "ECM client install for PreProd"
    Start-sleep 300
    Shutdown /r
    }
    elseif  ($myip4 -eq '2') 
    {
    #start-process $jdm -verb runas
    }
    }





#####################################################################################################

#Install Scom client
$jdm = $dm.$myip4.Scom

$Scomstatus =  Get-service -DisplayName 'Microsoft Monitoring Agent' -ErrorAction Ignore | select -ExpandProperty Status
if ($Scomstatus -eq 'Running')
{ 
Write-Host -F Green "Scom client successfully installed" 
}
else
{
if ( $myip4 -eq '3' )
    { 
    Powershell -executionpolicy bypass -file $jdm
    Write-Host -F Green "Scom client install from Dev"
    Start-sleep 90
    }
    elseif ($myip4 -eq '4') 
    {
    Powershell -executionpolicy bypass -file $jdm
    Write-Host -F Green "Scom client install from Test"
    Start-sleep 90
    }
    elseif  ($myip4 -eq '5') 
    {
    Powershell -executionpolicy bypass -file $jdm
    Write-Host -F Green "Scom client install from PreProd"
    Start-sleep 90
    }
    elseif  ($myip4 -eq '2') 
    {
    #start-process $jdm -verb runas
    }
    }
    



#####################################################################################################
#Set NIC parameters
$networkConfig = Get-WmiObject Win32_NetworkAdapterConfiguration -filter "ipenabled = 'true'"

If ( $networkConfig.DNSDomain -ne $domain )
    {
    $networkConfig.SetDnsDomain($domain)
    $networkConfig.SetDynamicDNSRegistration($true,$true)
    ipconfig /registerdns

    $base = "HKLM:SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces"

    $interfaces = Get-ChildItem $base | Select -ExpandProperty PSChildName
    foreach($interface in $interfaces) {
    Set-ItemProperty -Path "$base\$interface" -Name "NetbiosOptions" -Value 2
    }
    }
    else
    {
    Write-Host -F Green "Network Interface already configured"
    }

#####################################################################################################

Start-sleep 15

Write-Host -F Green "Final Checks.........."

$offline = Get-Disk | Where partitionstyle -eq ‘raw’ 
if ($offline.Count -eq 0) {
    Write-Host 'All disks are online' -F Green
} 
else 
{ 
Write-Host 'Check Disk Status' -F Green
}

$ecmstatus =  Get-service -DisplayName 'SMS Agent Host' | select -ExpandProperty Status
if ($ecmstatus -eq 'Running')
{ 
Write-Host -F Green "ECM client successfully installed" 
}
else
{
Write-Host -F Green "ECM client not installed"
}


$Scomstatus =  Get-service -DisplayName 'Microsoft Monitoring Agent' | select -ExpandProperty Status
if ($Scomstatus -eq 'Running')
{ 
Write-Host -F Green "Scom client successfully installed" 
}
else
{
Write-Host -F Green "Scom client not installed"
}

Write-Host -F Green "If all checks are Green build complete final reboot...."

Start-Sleep 15

Shutdown /r