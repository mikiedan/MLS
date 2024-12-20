#Defender checks
$defendercheck = GET-MpComputerStatus | select -expandproperty AMRunningMode
if ( $defendercheck -eq 'Normal')
{
Write-Host "Defender all good" -ForegroundColor Green
}
else
{
Write-Host "Check Defender install" -ForegroundColor Red
}


#Check CB installed and running
$cb =  Get-service -DisplayName 'Carbon Black App Control Agent' | select -ExpandProperty Status
if ( $cb -eq 'Running')
{
Write-Host "CB all good" -ForegroundColor Green
}
else
{
Write-Host "Problem with CB install may needs time to poll can, check later" -ForegroundColor Red
}

#Check SW installed and running
$swsrv =  Get-service -DisplayName 'SolarWinds Agent' | select -ExpandProperty Status
if ( $swsrv -eq 'Running')
{
Write-Host "SW Agent all good" -ForegroundColor Green
}
else
{
Write-Host "Problem with SW install may needs time to poll can, check later" -ForegroundColor Red
}

#Check Syslog installed and running
$syssrv =  Get-service -DisplayName 'syslog-ng Agent' | select -ExpandProperty Status
if ( $syssrv -eq 'Running')
{
Write-Host "Syslog Agent all good" -ForegroundColor Green
}
else
{
Write-Host "Problem with Syslog install may needs time to poll can check later" -ForegroundColor Red
}

#Check Sccm is installed and running
$sccmsrv =  Get-service -DisplayName 'SMS Agent Host' | select -ExpandProperty Status
if ( $sccmsrv -eq 'Running')
{
Write-Host "Sccm Agent all good" -ForegroundColor Green
}
else
{
Write-Host "Problem with Sccm please check" -ForegroundColor Red
}