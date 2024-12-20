Get-ADcomputer -Filter 'Name -like "C1*C*"' -Properties OperatingSystem,dnshostname,ipv4address  | where {$_.OperatingSystem -eq 'Windows Server 2012 R2 Datacenter'} | Select Name, Ipv4address


Get-ADcomputer -Filter 'Name -like "C1*C*"' -Properties OperatingSystem,dnshostname,ipv4address,LastLogonDate | 
    where {$_.lastlogondate -lt (Get-Date).AddDays(-760) } | 
        Select Name, Ipv4address, Lastlogondate

Get-ADComputer -Filter * -Properties Name,ipv4address | 
    Where-Object {$_.Name -match 'C10[A-C]+00+[0-1][0-6][0-6]'} |
        Select -ExpandProperty Name


#Get all AWs Devices Domain Controllers ending in 101 or 102
Get-ADComputer -Filter * -Properties Name,ipv4address |
    Where-Object {$_.Name -match 'C[1-4]*[A,C][C][0][0][1][0][1-2]'} |
        Select -ExpandProperty Name

Get-ADComputer -Filter * -Properties Name,ipv4address | 
    Where-Object {$_.Name -match 'C10[A-C]+00+[0-1][0-6][0-6]'} |
        Select -ExpandProperty Name


#Get all device with name starting with 019 and letters ending A-N
Get-Adcomputer -Filter * -Properties Name,ipv4address | 
    Where-Object {$_.Name -match '^019[A-N]'} |
        Select -ExpandProperty Name

#Get all devices ending with PH00 1-3 
Get-Adcomputer -Filter * -Properties Name,ipv4address | 
    Where-Object {$_.Name -match 'PH00[1-3]'} |
        Select -ExpandProperty Name

#Get all devices ending with VA0 0-9 
Get-Adcomputer -Filter * -Properties Name,ipv4address |
    Where-Object {$_.Name -match 'AVa0[0-9]'} |
        Select -ExpandProperty Name


$allaws= Get-Adcomputer -Filter * -Properties Name,ipv4address |
Where-Object {($_.Name -notmatch 'VA00[4]' -and ( $_.Name -notmatch 'VA00[2]' -and ( $_.Name -notmatch 'C10') -and ( $_.Name -notlike 'Cluster*')-and ( $_.Name -notlike 'SC*')))} | Select -ExpandProperty Name | sort Name 
$allaws.Count 


$teststring = ('C1AC00120','C1CC00120','C10CC00217')
$results = $teststring | Select-String -Pattern 'C[1-3](\d|\w)+00[1-4][0-5][0-9]' -AllMatches

$results.Matches.Value


#Get all AWs EC2 instances
Get-ADComputer -Filter * -Properties Name,ipv4address |
    Where-Object {$_.Name -match 'C[1-3](\d|\w)+00[1-4][0-5][0-9]'} |
        Select-Object -ExpandProperty Name


#Get all site Devices DCs
Get-ADComputer -Filter * -Properties Name,ipv4address |
    Where-Object {$_.Name -match '\d{3}[A-Za-z][vV][Aa]001'} |
        Select-Object -ExpandProperty Name

#Get all site Physical Devices
$sitevms = Get-ADComputer -Filter * -Properties Name,ipv4address |
    Where-Object {$_.Name -match '\d{3}[A-Za-z][pP][(Bb|Hh)]00[1-3]'} |
        Select-Object -ExpandProperty Name