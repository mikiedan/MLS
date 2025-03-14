# Replace 'NewUsername' with your desired username
$lastdigits = Read-Host = "Provide last 6 digit from asset label"

$Hostname = "LTP-O-" + $lastdigits

$Username = "LTPO" + $lastdigits

#Rename Device
Rename-Computer -NewName $Hostname 

# Set the password
$Password = ConvertTo-SecureString 'T3mpP@$$w0rd@2020' -AsPlainText -Force

# Create the local user
New-LocalUser -Name $Username -Password $Password -PasswordNeverExpires -AccountNeverExpires


