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


