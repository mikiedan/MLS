$GetHost = (hostname)
$Domain = 'Appt.local'
$Path =  "OU=Builder,DC=appt,DC=local"
$locationcode = '019'
$systemstack = 'S04'
$systemveh = 'D'
$systemped = 'P'
$siteip = '10.80.23.'
$siteipmask = '24'
$v190 = '11.0.32.'
$v190mask = '22'
$v170 = '10.80.22.'
$v170mask = '26'
$v2 = '10.0.32.'
$v2mask = '22'


Set-Location "Z:\"


# Import the CSV file
$csv = Import-Csv -Path "..\hash.csv"

# Initialize the hash table
$serverrole = @{}

# Populate the hash table
foreach ($row in $csv) {
    if (-not $serverrole.ContainsKey($row.Role)) {
        $serverrole[$row.Role] = @{}
    }
    $serverrole[$row.Role][$row.SubKey] = $row.Value
}

# Prompts user for role vm to build
$whatrole = Read-Host -Prompt "What server role is being built? DC, MGT0[1-4], SQL01-02, SCS01-02, P[1-9]-[1-4]"


# Display the hash table to pre prepare variables
$HNS = $serverrole.$whatrole.Locationcode + $serverrole.$whatrole.Systemstack + $serverrole.$whatrole.Hostname
$HIP1 = $serverrole.$whatrole.IP1
$HIP2 = $serverrole.$whatrole.IP2
$HIP3 = $serverrole.$whatrole.IP3
$HIP4 = $serverrole.$whatrole.IP4
$HNV = $serverrole.$whatrole.Locationcode + $serverrole.$whatrole.SystemVeh + $serverrole.$whatrole.Hostname
$HNP = $serverrole.$whatrole.Locationcode + $serverrole.$whatrole.SystemPed + $serverrole.$whatrole.Hostname
$NME1 = $serverrole.$whatrole.IPNM1
$NME2 = $serverrole.$whatrole.IPNM2
$NME3 = $serverrole.$whatrole.IPNM3
$NME4 = $serverrole.$whatrole.IPNM4

#Add in Ibeam Cursor to .default registry hive in order for all users
New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS
Set-ItemProperty -Path 'HKU:\.default\Control Panel\Cursors' -Name 'IBeam' -Value "%SystemRoot%\cursors\beam_r.cur"


#Check to see if machine has already been named
If ($GetHost -like 'WIN*')
{
    if ($whatrole -eq 'DC' -or $whatrole -match 'MGT0[1-3]')
    {
    #Write-Host -ForegroundColor Cyan "This is First"
    $rolename = $HNS #HostNameStack
    $roleip1 = $HIP1 #HostIP1
    $ipaddress1 = $siteip + $roleip1

    $if = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.Name -like 'Ethernet*' } | Select-Object -ExpandProperty Name | Sort-Object
    New-NetIpaddress -InterfaceAlias $if[0] -ipaddress $ipaddress1 -prefixlength $siteipmask -defaultgateway '10.80.23.1'
        Set-DnsClientServerAddress -Interfacealias $if[0] -ServerAddresses '10.201.3.11'
                Start-Sleep 3
            Rename-NetAdapter -Name $if[0] -NewName $NME1
                Start-Sleep 2
                    Disable-NetAdapter $if[1..3] -Confirm:$false

    $finalrolename = $sitename + $rolename 
    rename-computer -NewName $finalrolename
    Restart-Computer
    }
    elseif ($whatrole -match 'SQL0[1-2]')
    {
    #Write-Host -ForegroundColor Yellow "This is Second"
    $rolename = $HNS #HostNameStack
    $roleip1 = $HIP1 #HostIP1
    $ipaddress1 = $siteip + $roleip1
    $roleip3 = $HIP3
    $ipaddress3 = $v170 + $roleip3
       
        Start-Service -Name MSiSCSI
            Set-Service -Name MSiSCSI -StartupType Automatic
                Start-Sleep -Seconds 3 
                  
    $if = Get-NetAdapter -Name * | Where-Object {$_.Status -eq 'Up' -and $_.Name -like 'Ethernet*'} | Select-Object -ExpandProperty Name | Sort-Object
    New-NetIpaddress -Interfacealias $if[0] -ipaddress $ipaddress1 -prefixlength $siteipmask -defaultgateway '10.80.23.1'
        Set-DnsClientServerAddress -Interfacealias $if[0] -ServerAddresses '10.80.23.10,10.201.3.11'
            Rename-NetAdapter -Name $if[0] -NewName $NME1
                Start-Sleep -Seconds 3

    New-NetIpaddress -Interfacealias $if[2] -ipaddress $ipaddress3 -prefixlength $v170mask
        Rename-NetAdapter -Name $if[2] -NewName $NME3

    $if = Get-NetAdapter -Name * | Where-Object {$_.Status -eq 'Up' -and $_.Name -like 'Ethernet*'} | Select-Object -ExpandProperty Name | Sort-Object
                Disable-NetAdapter -Name $if -Confirm:$false

    $finalrolename = $sitename + $rolename 
    rename-computer -NewName $finalrolename
    Restart-Computer
    }
    elseif ($whatrole -match 'SCS0[1-2]')
    {
    #Write-Host -ForegroundColor Cyan "This will run if any of these are select"
    $rolename = $HNS #HostNameStack
    $roleip1 = $HIP1
    $ipaddress1 = $siteip + $roleip1

    $roleip2 = $HIP2
    $ipaddress2 = $v190 + $roleip2            

    $roleip3 = $HIP3
    $ipaddress3 = $v170 + $roleip3            

    $roleip4 = $HIP4
    $ipaddress4 = $v2 + $roleip4            
    
        Start-Service -Name MSiSCSI
            Set-Service -Name MSiSCSI -StartupType Automatic
                Start-Sleep -Seconds 3

    $if = Get-NetAdapter -Name * | Where-Object {$_.Status -eq 'Up' -and $_.Name -like 'Ethernet*'} | Select-Object -ExpandProperty Name | Sort-Object
    New-NetIpaddress -Interfacealias $if[0] -ipaddress $ipaddress1 -prefixlength $siteipmask -defaultgateway '10.80.23.1'
        Set-DnsClientServerAddress -Interfacealias $if[0] -ServerAddresses '10.80.23.10,10.201.3.11'
            Rename-NetAdapter -Name $if[0] -NewName $NME1
                Start-Sleep -Seconds 3
   
    New-NetIpaddress -Interfacealias $if[1] -ipaddress $ipaddress2 -prefixlength $v190mask
        Rename-NetAdapter -Name $if[1] -NewName $NME2
                Start-Sleep -Seconds 3

    New-NetIpaddress -Interfacealias $if[2] -ipaddress $ipaddress3 -prefixlength $v170mask
        Rename-NetAdapter -Name $if[2] -NewName $NME3
                Start-Sleep -Seconds 3

    New-NetIpaddress -Interfacealias $if[3] -ipaddress $ipaddress4 -prefixlength $v2mask
        Rename-NetAdapter -Name $if[3] -NewName $NME4

$finalrolename = $sitename + $rolename 
rename-computer -NewName $finalrolename
Restart-Computer
    }
    elseif ($whatrole -match 'P[1-9]-[1-4]') 
    {
    #Write-Host -ForegroundColor Cyan "This will run if any of these are select"
    
    $rolename = $HNV
    $roleip1 = $HIP1
    $ipaddress1 = $siteip + $roleip1

    $roleip2 = $HIP2
    $ipaddress2 = $v190 + $roleip2            

    $roleip3 = $HIP3
    $ipaddress3 = $v170 + $roleip3            

    $roleip4 = $HIP4
    $ipaddress4 = $v2 + $roleip4            
    
        Start-Service -Name MSiSCSI
            Set-Service -Name MSiSCSI -StartupType Automatic
                Start-Sleep -Seconds 3

    $if = Get-NetAdapter -Name * | Where-Object {$_.Status -eq 'Up' -and $_.Name -like 'Ethernet*'} | Select-Object -ExpandProperty Name | Sort-Object
    New-NetIpaddress -Interfacealias $if[0] -ipaddress $ipaddress1 -prefixlength $siteipmask -defaultgateway '10.80.23.1'
        Set-DnsClientServerAddress -Interfacealias $if[0] -ServerAddresses '10.80.23.10,10.201.3.11'
            Rename-NetAdapter -Name $if[0] -NewName $NME1
                Start-Sleep -Seconds 3
   
    New-NetIpaddress -Interfacealias $if[1] -ipaddress $ipaddress2 -prefixlength $v190mask
        Rename-NetAdapter -Name $if[1] -NewName $NME2
                Start-Sleep -Seconds 3

    New-NetIpaddress -Interfacealias $if[2] -ipaddress $ipaddress3 -prefixlength $v170mask
        Rename-NetAdapter -Name $if[2] -NewName $NME3
                Start-Sleep -Seconds 3

    New-NetIpaddress -Interfacealias $if[3] -ipaddress $ipaddress4 -prefixlength $v2mask
        Rename-NetAdapter -Name $if[3] -NewName $NME4

$finalrolename = $sitename + $rolename 
rename-computer -NewName $finalrolename
Restart-Computer
}

}
Start-Sleep 2

If ($Gethost -notlike 'WIN*')
{
Write-Host -ForegroundColor Cyan "Check Domain Status"
    $DS = (gwmi win32_computersystem).domain -eq 'WORKGROUP'
        If ($DS -eq $true)
            {
            Write-Host -ForegroundColor Cyan "Add vm to Domain"
            Add-Computer -ComputerName $GetHost -DomainName $Domain -Restart -OUPath $Path -Credential 'Appt\'
            }
            else
            {
            Write-Host -ForegroundColor Cyan "vm already in Domain"
            }
}


#Enable Iscsi initiator vms to attach storage
if ($Gethost -like '*SQL*' -or $Gethost -like '*SCS*' -or $Gethost -like '*LCS*')
{
Write-Host -ForegroundColor Cyan "Connect to Storage"
$iscsiportal = "10.80.22.151" #value need to change for each Nutanix cluster
    New-IscsiTargetPortal -TargetPortalAddress $iscsiportal

    $isciaddress = Get-IscsiTarget | Select-Object -ExpandProperty Nodeaddress

    foreach ( $trg in $isciaddress)
    {
    Connect-IscsiTarget -NodeAddress $trg -IsPersistent $true
    } 
}

#Disable netbios over tcpip for all network adapters
$base = "HKLM:SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces"

$interfaces = Get-ChildItem $base | Select-Object -ExpandProperty PSChildName

    foreach($interface in $interfaces) 
    {
    Set-ItemProperty -Path "$base\$interface" -Name "NetbiosOptions" -Value 2
    }



#Copy files needed to run FA build scripts
$staging = @('Scripts','Downloads','Install')

Foreach ($folder in $staging)
{
New-Item -ItemType Directory -Path "C:\$folder" -ErrorAction SilentlyContinue | Out-Null
}

$subfolderpath = Join-Path -Path "C:\Install" -ChildPath "Config"
New-Item -Path $subfolderpath -ItemType Directory -ErrorAction SilentlyContinue 
    Start-Sleep -Seconds 3

$nutanixNAS = '10.80.23.17'
$GetHost = (hostname)
$Localdst = 'C:\Scripts'
$LocalDWNdst = 'C:\Downloads'
$Localconfigdst = 'C:\Install\Config'


#Roles script folder
$A = '\\10.80.23.17\D$\Future Architecture\HCIStack\Install\20_Roles\'
#$B = '80_SCS01_Resiliant Service Node'
$C = '\*'
$D = $A + $B + $C

#Roles Download folder
$E = '\\10.80.23.17\D$\Future Architecture\HCIStackDownloads\'
#$F = '100_LCS_A SYS 1 Node'
$G = '\*'
$H = $E + $F + $G

#Copy Common Files to every vm that runs this scripts 
$K = '\\10.80.23.17\d$\Future Architecture\HCIStack\Install\00_Common'
$L = '\*'
$M = $K + $L
Copy-Item -Path $M -Destination $Localdst 

#Config files
$N = '\\10.80.23.17\d$\Future Architecture\HCIStack\Config'
$O = '\*'
$P = $N + $O
Copy-Item -Path $P -Destination $Localconfigdst 

   
if ($gethost -like '*LCS01')

        {
        Write-Host -ForegroundColor Green "Copying files to" $gethost
        $B = '100_LCS_A SYS1 Node'
        $D = $A + $B + $C
        $F = '100_LCS_A SYS 1 Node'
        
        $H = $E + $F + $G

            Copy-Item -Path $D -Destination $Localdst 
        Start-Sleep -Seconds 2

            Copy-Item -Path $H -Destination $LocalDWNdst -Recurse 
        Start-Sleep -Seconds 2

        }
        elseif ($gethost -like '*LCS02')
        {
        Write-Host -ForegroundColor Green "Copying files to" $gethost
        $B = '110_LCS_B SYS1 Node'
        
        $D = $A + $B + $C
        
        $F = '100_LCS_A SYS 1 Node'
        
        $H = $E + $F + $G

            Copy-Item -Path $D -Destination $Localdst 

        Start-Sleep -Seconds 3

            Copy-Item -Path $H -Destination $LocalDWNdst -Recurse 
        }
        elseif ($gethost -like '*SCS01')
        {
        Write-Host -ForegroundColor Green "Copying files to" $gethost
        $B = '80_SCS01_Resiliant Service Node'
        
        $D = $A + $B + $C
        
        $F = '100_LCS_A SYS 1 Node'
        
        $H = $E + $F + $G

            Copy-Item -Path $D -Destination $Localdst

        Start-Sleep -Seconds 3

            Copy-Item -Path $H -Destination $LocalDWNdst -Recurse
        }
        elseif ($gethost -like '*SCS02')
        {
        Write-Host -ForegroundColor Green "Copying files to" $gethost
        $B = '90_SCS02_Resiliant Service Node'
        
        $D = $A + $B + $C
        
        $F = '100_LCS_A SYS 1 Node'
        
        $H = $E + $F + $G

            Copy-Item -Path $D -Destination $Localdst

        Start-Sleep -Seconds 3

            Copy-Item -Path $H -Destination $LocalDWNdst -Recurse
        }
        elseif ($gethost -like '*SQL01')
        {
        Write-Host -ForegroundColor Green "Copying files to" $gethost
        $B = '20_SQL_A'
        
        $D = $A + $B + $C
        
        $F = '20_SQL_A'
        
        $H = $E + $F + $G

            Copy-Item -Path $D -Destination $Localdst

        Start-Sleep -Seconds 3

            Copy-Item -Path $H -Destination $LocalDWNdst -Recurse
        }
        elseif ($gethost -like '*SQL02')
        {
        Write-Host -ForegroundColor Green "Copying files to" $gethost
        $B = '30_SQL_B'
        
        $D = $A + $B + $C
        
        $F = '30_SQL_B'
        
        $H = $E + $F + $G

            Copy-Item -Path $D -Destination $Localdst

        Start-Sleep -Seconds 3

            Copy-Item -Path $H -Destination $LocalDWNdst -Recurse
        }
        elseif ($gethost -like '*DC01')
        {
        Write-Host -ForegroundColor Green "Copying files to" $gethost
        $B = '10_DC'
        
        $D = $A + $B + $C
        
        $F = '10_DC'
        
        $H = $E + $F + $G

            Copy-Item -Path $D -Destination $Localdst

        Start-Sleep -Seconds 3

            Copy-Item -Path $H -Destination $LocalDWNdst -Recurse
        }
        elseif ($gethost -like '*MGT01')
        {
        Write-Host -ForegroundColor Green "Copying files to" $gethost
        $B = '40_MGT01_SCOM'
        
        $D = $A + $B + $C
        
        $F = ''
        
        $H = $E + $F + $G

            Copy-Item -Path $D -Destination $Localdst

        Start-Sleep -Seconds 3

            Copy-Item -Path $H -Destination $LocalDWNdst -Recurse
        }
        elseif ($gethost -like '*MGT02')
        {
        Write-Host -ForegroundColor Green "Copying files to" $gethost
        $B = '50_MGT02_SCOM_GW'
        
        $D = $A + $B + $C
        
        $F = ''
        
        $H = $E + $F + $G

            Copy-Item -Path $D -Destination $Localdst

        Start-Sleep -Seconds 3

            Copy-Item -Path $H -Destination $LocalDWNdst -Recurse
        }
        elseif ($gethost -like '*MGT03')
        {
        Write-Host -ForegroundColor Green "Copying files to" $gethost
        $B = '60_MGT03_DP'
        
        $D = $A + $B + $C
        
        $F = '60_MGT03_DP'
        
        $H = $E + $F + $G

            Copy-Item -Path $D -Destination $Localdst -Recurse

        Start-Sleep -Seconds 3

            Copy-Item -Path $H -Destination $LocalDWNdst -Recurse
            New-Item -Path "C:\NO_SMS_DRIVE.SMS" -ItemType "File"
        }
        elseif ($gethost -like '*MGT04')
        {
        Write-Host -ForegroundColor Green "Copying files to" $gethost
        $B = '70_MGT04_ANS'
        
        $D = $A + $B + $C
        
        $F = ''
        
        $H = $E + $F + $G

            Copy-Item -Path $D -Destination $Localdst

        Start-Sleep -Seconds 3

            Copy-Item -Path $H -Destination $LocalDWNdst -Recurse
        }
  
    else
    {
    Write-host -ForegroundColor Cyan "Files already copied"
    }
