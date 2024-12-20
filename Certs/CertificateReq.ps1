$domainfqdn = $env:USERDNSDOMAIN
$GetHost = (hostname)
$fqdn = $GetHost + '.'+ $domainfqdn
$ca = certutil –dump
$ca | out-file -FilePath C:\scripts\ml\pki.txt
$ca = Get-Content -Path C:\scripts\ml\pki.txt -TotalCount 8 | select -Last 1
$ca5= $ca.Replace('  Config:                 	`',"")
$ca6 = $ca5.TrimEnd("'")

Set-Location -Path 'C:\scripts\ml\'

certreq -new -q Cert_Request.inf ns.req
certreq -submit -q -config $ca6 ns.req ns.cer
certreq -accept -machine ns.cer

Remove-Item -Path 'C:\scripts\ml\ns*'


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
