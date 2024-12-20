#Get information from existing 2012 server Instance
$existingvm = Read-Host -Prompt "HostName of 2012 Server?"
$migration = $existingvm.ToUpper()
$zoneId = $migration.Substring(2,2)
$zoneId2 = $migration.Substring(3,2)
$prodnonprod = $migration.Substring(0,3)


#Refer to AWS migration spreadsheet for last 3 numbers of servername column D
$lastthree = Read-Host -Prompt "Last 3 numbers of Server being built"

#Enter name of AWS Name taken from Spreadsheet column G
$AWSlastthree = Read-Host -Prompt "Last characters of AWS server name being built"

#Enter Role or Service Name from Spreadsheet column B
#$Roleservice = Read-Host -Prompt "Enter Service Name of instance"

#Get existing instance info
$instidresult = (Get-EC2Instance -Filter @( @{name='tag:HostName'; values="$migration"})).Instances |
    Select-Object -Expandproperty InstanceID

#Get 2012 server's Group membership for SGS1, SGDM, SGSite etc
$groupidresult = (Get-EC2InstanceAttribute -InstanceId $instidresult -Attribute groupset).Groups |
    Select-Object -Expandproperty GroupID

#Get 2012 server's Subnet ID
$subidresult = (Get-EC2Instance).Instances |
    Where-Object {$_.instanceID -eq "$instidresult"} |
        Select-Object -Expandproperty SubnetID

#Role or Service Name
$Roleservice = Get-EC2Tag -Filter @{Name="resource-id";Values="$instidresult"} | Where-Object {$_.Key -eq 'Role'} | Select-Object -ExpandProperty Value

#Get 2012 server's Instance Type eg:t2.small
$machinetype = (Get-EC2InstanceAttribute -InstanceId $instidresult -Attribute instanceType).InstanceType


#Get 2012 IP to find out what environment  
$instIP = (Get-EC2Instance -InstanceId $instidresult).Instances | Select-Object -ExpandProperty PrivateIPaddress

#Info for If
$envi = $instIP.Substring(7,1)

#Info for If
$envi2 = $instIP.Substring(3,4)

If ($prodnonprod -eq 'C10')
    {
    $ENV1 = 'Production'
    $ENV2 = 'PRD'
    $Reg = 'Eu-West-2'
    }
else{
    $ENV1 = 'Non Production'
    $ENV2 = 'NPD'
    $Reg = 'Eu-West-1'
    }
    

#Get Enviroment hash table 
$Whatdomain =     @{
                    '1' = @{'DMZTCYC' =  @{'AWSName' = 'DMZTCYC'
                                          'HostnameAC'= 'C1AC00'
                                          'HostnameCC' = 'C1CC00'
                                          'Env' = 'Dmzt.Local'
                                          }
                            }

                    '2' = @{'DMZTCYC' =  @{'AWSName' = 'DMZTCYC'
                                          'HostnameAC'= 'C1AC00'
                                          'HostnameCC' = 'C1CC00'
                                          'Env' = 'Dmzt.Local'
                                          }
                            }
                  
                   
                    '3' = @{'DEVCYC' = @{'AWSName' = 'DEVCYC'
                                         'HostnameAC' = 'C2AC00'
                                         'HostnameCC' = 'C2CC00'
                                         'Env' = 'Appt.Local'
                                          }
                            }
                             
                         
                    '4' = @{'TSTCYC' = @{'AWSName' = 'TSTCYC'
                                         'HostnameAC' = 'C1AC00'
                                         'HostnameCC' = 'C1CC00'
                                         'Env' = 'Test.Local'
                                         }
                            }

                    '5' = @{'PRETCYC'  =@{'AWSName' = 'PRETCYC'
                                         'HostnameAC' = 'C3AC00'
                                         'HostnameCC' = 'C3CC00'
                                         'Env' = 'Pret.Local'
                                         }
                            }

                    '38.4' = @{'PRDDMZCYC'  =@{'AWSName' = 'PRDDMZCYC'
                                         'HostnameAC' = 'C10AC00'
                                         'HostnameCC' = 'C10CC00'
                                         'Env' = 'Dmz.Local'
                                         }
                            }

                    '38.5' = @{'PRDPLATCYC'  =@{'AWSName' = 'PRDCYC'
                                         'HostnameAC' = 'C10AC00'
                                         'HostnameCC' = 'C10CC00'
                                         'Env' = 'Cycitplatprod.Local'
                                         }
                            }

}



#Non Production Tag info
If ($envi -eq 1 -and $zoneId -eq 'AC')
    {
    $HN = $Whatdomain.'1'.DMZTCYC.HostnameAC + $lastthree
    $AWSN = $Whatdomain.'1'.DMZTCYC.AWSName + $AWSlastthree
    $AZ = "eu-west-1a"
    $TENV = $Whatdomain.'1'.DMZTCYC.Env
    $ENV = "NPD"
    }

elseif ($envi -eq 2 -and $zoneId -eq 'AC')
    {
    $HN = $Whatdomain.'2'.DMZTCYC.HostnameAC + $lastthree
    $AWSN = $Whatdomain.'2'.DMZTCYC.AWSName + $AWSlastthree
    $AZ = "eu-west-1a"
    $TENV = $Whatdomain.'2'.DMZTCYC.Env
    $ENV = "NPD"
    }

elseif ($envi -eq 2 -and $zoneId -eq 'CC')
    {
    $HN = $Whatdomain.'2'.DMZTCYC.HostnameCC + $lastthree
    $AWSN = $Whatdomain.'2'.DMZTCYC.AWSName + $AWSlastthree
    $AZ = "eu-west-1c"
    $TENV = $Whatdomain.'2'.DMZTCYC.Env
    $ENV = "NPD"
    }
      
elseif ($envi -eq 3 -and $zoneId -eq 'AC')
    {
    $HN = $Whatdomain.'3'.DEVCYC.HostnameAC + $lastthree
    $AWSN = $Whatdomain.'3'.DEVCYC.AWSName + $AWSlastthree
    $AZ = "eu-west-1a"
    $TENV = $Whatdomain.'3'.DEVCYC.Env
    $ENV = "NPD"
    }

elseif ($envi -eq 3 -and $zoneId -eq 'CC')
    {
    $HN = $Whatdomain.'3'.DEVCYC.HostnameCC + $lastthree
    $AWSN = $Whatdomain.'3'.DEVCYC.AWSName + $AWSlastthree
    $AZ = "eu-west-1c"
    $TENV = $Whatdomain.'3'.DEVCYC.Env
    $ENV = "NPD"
    }

elseif ($envi -eq 4 -and $zoneId -eq 'AC')
    {
    $HN = $Whatdomain.'4'.TSTCYC.HostnameAC + $lastthree
    $AWSN = $Whatdomain.'4'.TSTCYC.AWSName + $AWSlastthree
    $AZ = "eu-west-1a"
    $TENV = $Whatdomain.'4'.TSTCYC.Env
    $ENV = "NPD"
    }

elseif ($envi -eq 4 -and $zoneId -eq 'CC')
    {
    $HN = $Whatdomain.'4'.TSTCYC.HostnameCC + $lastthree
    $AWSN = $Whatdomain.'4'.TSTCYC.AWSName + $AWSlastthree
    $AZ = "eu-west-1c"
    $TENV = $Whatdomain.'4'.TSTCYC.Env
    $ENV = "NPD"
    }

elseif ($envi -eq 5 -and $zoneId -eq 'AC')
    {
    $HN = $Whatdomain.'5'.PRETCYC.HostnameAC + $lastthree
    $AWSN = $Whatdomain.'5'.PRETCYC.AWSName + $AWSlastthree
    $AZ = "eu-west-1a"
    $TENV = $Whatdomain.'5'.PRETCYC.Env
    $ENV = "NPD"
    }
    
elseif ($envi -eq 5 -and $zoneId -eq 'CC')
    {
    $HN = $Whatdomain.'5'.PRETCYC.HostnameCC + $lastthree
    $AWSN = $Whatdomain.'5'.PRETCYC.AWSName + $AWSlastthree
    $AZ = "eu-west-1c"
    $TENV = $Whatdomain.'5'.PRETCYC.Env
    $ENV = "NPD"
    }


#Production Tag info
If ($envi2 -eq '38.4' -and $zoneId2 -eq 'AC')
    {
    $HN = $Whatdomain.'38.4'.PRDDMZCYC.HostnameAC + $lastthree
    $AWSN = $Whatdomain.'38.4'.PRDDMZCYC.AWSName + $AWSlastthree
    $AZ = "eu-west-2a"
    $TENV = $Whatdomain.'38.4'.PRDDMZCYC.Env
    $ENV = "PRD"
    }
elseif ($envi2 -eq '38.4' -and $zoneId2 -eq 'CC')
    {
    $HN = $Whatdomain.'38.4'.PRDDMZCYC.HostnameCC + $lastthree
    $AWSN = $Whatdomain.'38.4'.PRDDMZCYC.AWSName + $AWSlastthree
    $AZ = "eu-west-2c"
    $TENV = $Whatdomain.'38.4'.PRDDMZCYC.Env
    $ENV = "PRD"
    $Keyname = '$Keynamevalue'
    }
elseif ($envi2 -eq '38.5' -and $zoneId2 -eq 'AC')
    {
    $HN = $Whatdomain.'38.5'.PRDPLATCYC.HostnameAC + $lastthree
    $AWSN = $Whatdomain.'38.5'.PRDPLATCYC.AWSName + $AWSlastthree
    $AZ = "eu-west-2a"
    $TENV = $Whatdomain.'38.5'.PRDPLATCYC.Env
    $ENV = "PRD"
    }
elseif ($envi2 -eq '38.5' -and $zoneId2 -eq 'CC')
    {
    $HN = $Whatdomain.'38.5'.PRDPLATCYC.HostnameAC + $lastthree
    $AWSN = $Whatdomain.'38.5'.PRDPLATCYC.AWSName + $AWSlastthree
    $AZ = "eu-west-2a"
    $TENV = $Whatdomain.'38.5'.PRDPLATCYC.Env
    $ENV = "PRD"
    }


#Enter Key Name 
#$keynamevalue = "SCOM-Key-Pair"
#$keyname = $keynamevalue
#$keynamevalue = "Win2016"
#$keynamevalue = "Win2016"



##################################################################################################################################################
#Find AWS AMI for Microsoft Windows 2016-2022 OS to build

$whatOS = Read-Host -Prompt "Which OS to build 2016 or 2022 ?" 

$dates = (Get-Date).addDays(-25)
$dates2 = $dates.ToString('yyyy-MM')


if ($whatOS -eq '2016')

    {

    #Search for OS by ami
    $whichwinimage = Get-EC2Image -Owner amazon, self | 
        Where-Object {$_.Name -match '^Windows_Server-2016-English-Full-Base' -and ($_.Creationdate -gt $dates2)} | Sort-Object Creationdate |
            Select-Object -ExpandProperty ImageID

    #Search for OS by name
    $winimage1 = Get-EC2Image -Owner amazon, self | 
        Where-Object {$_.Name -match '^Windows_Server-2016-English-Full-Base' -and ($_.Creationdate -gt $dates2)} | Sort-Object Creationdate |
            Select-Object -ExpandProperty Description

    $winimage = $whichwinimage[0]  
    Write-Host -ForegroundColor Green "Building Windows 2016 OS..." 
    $OS = $winimage1.substring(0,29)
    $BuildOS = $OS[0]
    $keynamevalue = "Win2016"
    $keyname = $keynamevalue
    }
else
    {

    #Search for OS by ami
    $whichwinimage = Get-EC2Image -Owner amazon, self | 
        Where-Object {$_.Name -match '^Windows_Server-2022-English-Full-Base' -and ($_.Creationdate -gt $dates2)} | Sort-Object Creationdate |
            Select-Object -ExpandProperty ImageID

    #Search for OS by name
    $winimage2 = Get-EC2Image -Owner amazon, self | 
        Where-Object {$_.Name -match '^Windows_Server-2022-English-Full-Base' -and ($_.Creationdate -gt $dates2)} | Sort-Object Creationdate |
            Select-Object Description,Creationdate,Name

    $winimage = $whichwinimage[0] 
    Write-Host -ForegroundColor Cyan "Building Windows 2022 OS..."
    $OS = $winimage2.substring(0,29)
    $BuildOS = $OS[0]
    $keynamevalue = "SCOM-Key-Pair"
    $keyname = $keynamevalue
    }

#$BuildOS = $winimage2.substring(0,29)
<#
if ( $whatos -eq '2016')
{
    $winimage = $whichwinimage[0]  
    Write-Host -ForegroundColor Green "Building Windows 2016 OS..." 
    $OS = $winimage1.substring(0,29)
    $BuildOS = $OS[0]
    $keynamevalue = "Win2016"
    $keyname = $keynamevalue
}
else
{ 
    $winimage = $whichwinimage[1] 
    Write-Host -ForegroundColor Cyan "Building Windows 2022 OS..."
    $OS = $winimage2.substring(0,29)
    $BuildOS = $OS[1]
    $keynamevalue = "SCOM-Key-Pair"
    $keyname = $keynamevalue
}
#>
##################################################################################################################################################


#For Non Prod or Production


    $Tags1 = @( @{key="ServiceCode";value="CYC"} 
           @{key="Environment";value="$TENV"}
           @{key="Project";value="CYC"}
           @{key="ServiceName";value="Cyclamen " + "$ENV1 " + "Services"}
           @{key="HostName";value="$HN"}
           @{key="Name";value="$AWSN"}
           @{key="ServiceType";value="$ENV2"}
           @{key="Region";value="$Reg"}
           @{key="Description";value="$ENV " + "$Roleservice " + "$BuildOS"}
           @{key="ID";value="$ENV" +"CYC"} 
           @{key="Role";value=$Roleservice} )


#Creating new Server
$newec2 = New-EC2Instance -ImageId $winimage -KeyName $keyname -MaxCount 1 -InstanceType $machinetype -SubnetId $subidresult -SecurityGroupID $groupidresult |
    Select-Object -ExpandProperty ReservationId

Start-Sleep -Seconds 5

#Get Reservation ID for Tagging"
$newinstanceidresult = (Get-EC2Instance -Filter @{Name = "reservation-id";values = "$newec2"}).Instances |
    Select-Object -Expandproperty InstanceID


Start-Sleep -Seconds 5

#Get OS volume for tagging
$osvolididresult = Get-EC2Volume -Filter @{ Name="attachment.instance-id"; Values="$newinstanceidresult" } |
    Select-Object -Expandproperty VolumeID

#Get Instance IP and NIC for tagging
$instanceipresult = (Get-EC2Instance -InstanceId $newinstanceidresult).Instances | 
    Select-Object -ExpandProperty PrivateIPaddress 
$nicidresult = Get-EC2NetworkInterface | Where-Object {$_.PrivateIpAddress -eq "$instanceipresult"} |
    Select-Object -ExpandProperty NetworkInterfaceId


#Tag all your resources OS Volume, Additional Disk, Network NIC
New-EC2Tag  -ResourceId $osvolididresult,$newinstanceidresult,$nicidresult -Tags $Tags1


#Change OS disk to 128Gb and GP3
Edit-EC2Volume -volumeID $osvolididresult -Size 128 -VolumeType gp3