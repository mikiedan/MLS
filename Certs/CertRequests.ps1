###########################################
#Define the domain 
$domainfqdn = $env:USERDNSDOMAIN
#Get Hostname 
$GetHost = (hostname)
#Create FQDN
$fqdn = $GetHost + '.'+ $domainfqdn
#Name of thefile to create which will contain Domain's CA
$domainca = 'pki.txt'
#Define a local folder path to create
$mlfolderpath = 'C:\microland\ml\pki'
#Define Certificate Request inf file
$CertfileName = "Cert_Request.inf"

#File creation
$filename = Join-Path $mlfolderpath -ChildPath $domainca


#Create folder path and file if not exist
if (-not(Test-Path $mlfolderpath))
    {New-Item -ItemType Directory -Path $mlfolderpath
    }
    else
    {
    Write-Output "Folder exist"
    }

#Dump out Ca details to retrieve CA name
$ca = certutil –dump
#Output to a file
$ca | out-file -FilePath $filename
#Get CA name details from file
$ca = Get-Content -Path $filename -TotalCount 8 | select -Last 1
#Tidy details
$ca2= $ca.Replace('  Config:                 	`',"")
#Tidy details
$ca3 = $ca2.TrimEnd("'")

#Set path location
Set-Location -Path $mlfolderpath

###########################################
#Create a temp .inf file with details for certificate and delete once it has been created.
$infContents = @"

#Typical Cert_Request.inf file 
###########################################
[newrequest]
; At least one value must be set in this section
subject = "CN=$fqdn,OU=Cyclamen,O=Home Office,C=GB"
Exportable = False
ProviderName = "Microsoft RSA SChannel Cryptographic Provider"
ExportableEncrypted = False
HashAlgorithm = sha256
KeyAlgorithm = RSA
KeyLength = 2048
KeyUsage = CERT_DIGITAL_SIGNATURE_KEY_USAGE | CERT_KEY_ENCIPHERMENT_KEY_USAGE
MachineKeySet = True
[RequestAttributes]
CertificateTemplate= SSLWebServer

[Extensions]
2.5.29.17 = "{text}"
_continue_ = "DNS=$fqdn"
"@

#Define path and file creation for Cert_Request.inf
$CertfileNamePath = Join-Path $mlfolderpath -ChildPath $CertfileName
#Create Cert_Request.inf file
$infContents | Out-File -FilePath $CertfileNamePath -Encoding ASCII

# Output success message
Write-Host "Cert_Request.inf file created at: $mlfolderpath"
###########################################

#Create Certifcate request with details from the Cert_Request.inf file
certreq -new -q Cert_Request.inf ns.req
#Submit request to Domain's CA
certreq -submit -q -config $ca3 ns.req ns.cer
#Bind signed request to local machine
certreq -accept -machine ns.cer

#Clean up
Remove-Item -Path $mlfolderpath -Recurse -Force