<#
.SYNOPSIS
   Exports Rid Certificate with password protected key

.DESCRIPTION


.NOTES
      Company : Leonardo

    Ver     Date      Who  What
    ======  ========  ===  ==================================================
    0.0.1   21/04/23  ML   Initial release


#>


#region Functions
####################################################################

function MapZDrive() {
    $ip = ((Get-NetIPAddress -InterfaceAlias 'Ethernet0').IPv4Address)
    $ipArray = $ip -split '\.'
    $NasAddress = $ipArray[1] + '.' + $ipArray[2] + '.' + $ipArray[3] + '.140'

    net use z: $('\\' + $nasAddress + '\install')
}

#map drive, load utils
####################################################################

$check = Test-Path 'z:\'
if ($check -eq $false) {
    MapZDrive
    $check = Test-Path 'z:\'
    if ($check -eq $false) {
        throw 'No Z: Drive'
    }
    Copy-Item -Path z:\utils.ps1 -Destination c:\scripts\utils.ps1
}

. C:\scripts\Utils.ps1


#main script
####################################################################
  
#create ML Folder
InfoMessage "Creating C:\scripts\Rids folder... " -NoNewLine
New-Item -ItemType Directory C:\scripts\Rids_Cert\ -ErrorAction SilentlyContinue | Out-Null
InfoMessage "Folder created." -ForegroundColor Green

# Export Cert as a PKCS File Password protected as it contains private key:
InfoMessage "Exporting Rid Client Certificate as .p12 file... " -NoNewLine
$CertCheck = 'CN=Rids.*'
$cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -match $Certcheck}
$CBAPKCPassword = Decrypt-String (GetConfigItem CBAPKCPassword)
$mypassword = ConvertTo-SecureString -String $CBAPKCPassword -Force -AsPlainText
$certthumb = (Get-ChildItem -Path "Cert:\LocalMachine\My\$($cert.thumbprint)").thumbprint

#Export Rid Certificate from Store to Location
Export-PfxCertificate -Cert (Get-ChildItem -Path "Cert:\LocalMachine\My\$certthumb") -FilePath "C:\scripts\Rids_Cert\$certthumb.p12" -Password $mypassword | Out-Null

Get-ChildItem -Path Cert:\LocalMachine\My\ | Where-Object {$_.Subject -match $Certcheck} | Select SerialNumber | Out-file -FilePath "C:\scripts\Rids_Cert\$certthumb.txt"

$thumbfile1 = Get-Item 'C:\scripts\Rids_Cert\*.txt'
$Certfile = Get-Content $thumbfile1 -TotalCount 4 | Select -Last 1
$result = $Certfile.Substring(0,37)
$SerialNumber = "$result"+".p12"
$thumbfile2 = Get-Item 'C:\scripts\Rids_Cert\*.p12'

Rename-Item $thumbfile2 -NewName $SerialNumber
Remove-Item $thumbfile1

InfoMessage "Use $CBAPKCPassword for Certificate Import Password" -ForegroundColor Yellow
InfoMessage "Generation complete" -ForegroundColor Green


####################################################################
#end of script

