$domainfqdn = $env:USERDNSDOMAIN
$GetHost = (hostname)
$fqdn = $GetHost + '.'+ $domainfqdn
$domainca = 'pki.txt'
$mlfolderpath = 'C:\microland\ml\pki'

$filename = Join-Path $mlfolderpath -ChildPath $domainca


if (-not(Test-Path $mlfolderpath))
    {New-Item -ItemType Directory -Path $mlfolderpath
    }
    else
    {
    Write-Output "Folder exist"
    }

$ca = certutil –dump
$ca | out-file -FilePath $filename
$ca = Get-Content -Path $filename -TotalCount 8 | select -Last 1
$ca2= $ca.Replace('  Config:                 	`',"")
$ca3 = $ca2.TrimEnd("'")

#Set-Location -Path $mlfolderpath

certreq -new -q Cert_Request.inf ns.req
certreq -submit -q -config $ca3 ns.req ns.cer
certreq -accept -machine ns.cer

Remove-Item -Path $mlfolderpath -Recurse


#Typical Cert_Request.inf file 
###########################################
[newrequest]
; At least one value must be set in this section
subject = "CN=Rids.Test.Local,OU=Cyclamen,O=Home Office,C=GB"
Exportable = True
ProviderName = "Microsoft RSA SChannel Cryptographic Provider"
ExportableEncrypted = True
HashAlgorithm = sha256
KeyAlgorithm = RSA
KeyLength = 2048
KeyUsage = CERT_DIGITAL_SIGNATURE_KEY_USAGE | CERT_KEY_ENCIPHERMENT_KEY_USAGE
MachineKeySet = True
[RequestAttributes]
CertificateTemplate= Rids_Long_Cert

[Extensions]
2.5.29.17 = "{text}"
_continue_ = "DNS=019ava023.test.local&"
_continue_ = "DNS=rids.test.local"
###########################################

[newrequest]
; At least one value must be set in this section
subject = "CN=019-S25-SCS01,OU=Cyclamen,O=Home Office,C=GB"
Exportable = True
ProviderName = "Microsoft RSA SChannel Cryptographic Provider"
ExportableEncrypted = True
HashAlgorithm = sha256
KeyAlgorithm = RSA
KeyLength = 2048
KeyUsage = CERT_DIGITAL_SIGNATURE_KEY_USAGE | CERT_KEY_ENCIPHERMENT_KEY_USAGE
MachineKeySet = True
[RequestAttributes]
CertificateTemplate= RestfulAPI SSL

[Extensions]
2.5.29.17 = "{text}"
_continue_ = "DNS=019-S25-SCS01.appt.local&"
_continue_ = "DNS=019-S25-SCS02.appt.local"


#Typical Cert_Request.inf file 
###########################################
[newrequest]
; At least one value must be set in this section
subject = "CN=C2ac00105.Appt.Local,OU=Cyclamen,O=Home Office,C=GB"
Exportable = False
ProviderName = "Microsoft RSA SChannel Cryptographic Provider"
ExportableEncrypted = True
HashAlgorithm = sha256
KeyAlgorithm = RSA
KeyLength = 2048
KeyUsage = CERT_DIGITAL_SIGNATURE_KEY_USAGE | CERT_KEY_ENCIPHERMENT_KEY_USAGE
MachineKeySet = True
[RequestAttributes]
CertificateTemplate= SSLWebServer

[Extensions]
2.5.29.17 = "{text}"
_continue_ = "DNS=C2ac00105.appt.local"
#_continue_ = "DNS=rids.test.local"
