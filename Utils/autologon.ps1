# Define the registry key path
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

# Set the values for the keys
Set-ItemProperty -Path $RegistryPath -Name "DefaultUserName" -Value "Admin2"
Set-ItemProperty -Path $RegistryPath -Name "DefaultPassword" -Value 'T3mpP@$$w0rd@2020'
Set-ItemProperty -Path $RegistryPath -Name "AutoAdminLogon" -Value "1"

Write-Host "Registry keys have been updated successfully."
