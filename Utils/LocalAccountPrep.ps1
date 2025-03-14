#Create Folders
$staging = @("OfflineCA","OnlineCA")
Foreach ($folder in $staging)
{
New-Item -ItemType Directory -Path "C:\Microland\$folder" -ErrorAction SilentlyContinue | Out-Null
}

#Prompt for Secure String password
$Password = Read-Host -AsSecureString

#Create LocalRootCA Admin Accounts
New-LocalUser "mleadmin" -Password $Password -FullName "Microland Local Admins" -Description "CA Administrator Account" -PasswordNeverExpires


#Add to Local Admin
Add-LocalGroupMember -Group "Administrators" -Member "mleadmin" 






# Replace 'NewUsername' with your desired username
$lastdigits = Read-Host = "Provide last 6 digit from asset label"

$Hostname = "LTP-O-" + $lastdigits

$Username = "LTPO" + $lastdigits

#Rename Device
Rename-Computer -ComputerName $Hostname 

# Set the password
$Password = ConvertTo-SecureString 'T3mpP@$$w0rd@2020' -AsPlainText -Force

# Create the local user
New-LocalUser -Name $Username -Password $Password -PasswordNeverExpires -AccountNeverExpires

# Optionally add the user to the Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $Username

#Create LocalRootCA Admin Accounts
New-LocalUser "mleadmin" -Password $Password -FullName "Microland Local Admins" -Description "CA Administrator Account" -PasswordNeverExpires




