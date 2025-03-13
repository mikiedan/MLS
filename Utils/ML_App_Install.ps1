#Applications list install
 
Add-Type -AssemblyName microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms
 
#Start Application CiscoAMP 8.2.1.21650
#Start-Process -FilePath 'C:\ML Apps 1224\CiscoAMP 8.2.1.21650\AMP_EndPoint_8.2.1.21650.exe'
#Start-Sleep -Seconds 5
 
# Activate the installer window
#[Microsoft.VisualBasic.Interaction]::AppActivate("Cisco Secure Endpoint Setup")
 
# Send keystrokes to interact with the installer
#[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
#Start-Sleep -Seconds 60
#####################################################################################################
 
#Start Application CiscoSecure_HDU 5.1.4.42
Start-Process -FilePath "C:\ML Apps 1224\Ciscosecure_HDU 5.1.2.42\CiscosecureVPNwithoutAMP.exe"
Start-Sleep -Seconds 10
 
 
# Activate the installer window
[Microsoft.VisualBasic.Interaction]::AppActivate("Setup - CiscosecureVPNwitoutAMP version 5.1.2.42")
 
 
# Send keystrokes to interact with the installer
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
Start-Sleep -Seconds 45
 
#$proc.WaitForInputIdle()
 
 
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
Start-Sleep -Seconds 5
#####################################################################################################
 
#Start Application CiscoSecureVPN
Start-Process -FilePath "C:\ML Apps 1224\CiscoSecureVPN\CiscoSecureVPNMDT.exe"
Start-Sleep -Seconds 10
 
# Activate the installer window
[Microsoft.VisualBasic.Interaction]::AppActivate("Setup - CiscoSecureVPNMDT version 1.1.2.6")
 
 
# Send keystrokes to interact with the installer
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
Start-Sleep -Seconds 30
 
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
Start-Sleep -Seconds 10
#####################################################################################################
 
#Start Application Zscaler Agent 4.1.0.102
Start-Process -FilePath "C:\ML Apps 1224\Zscaler Agent 4.1.0.102\Zscaler-windows-4.1.0.102-installer-x64.exe"
Start-Sleep -Seconds 15
 
# Activate the installer window
[Microsoft.VisualBasic.Interaction]::AppActivate("Zscaler Setup")
 
 
# Send keystrokes to interact with the installer
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
Start-Sleep -Seconds 5
 
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
Start-Sleep -Seconds 30
 
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
Start-Sleep -Seconds 30
#####################################################################################################
 
# Start Application Ciscosecure_Corp 5.1.2.14
Start-Process -FilePath "C:\ML Apps 1224\Ciscosecure_Corp 5.1.2.14\CiscosecureVPNwithoutAMP.exe"
Start-Sleep -Seconds 5
 
# Activate the installer window
[Microsoft.VisualBasic.Interaction]::AppActivate("Setup - CiscosecureVPNwitoutAMP version 5.1.2.42")
Start-Sleep -Milliseconds 2500
 
# Send keystrokes to interact with the installer
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
Start-Sleep -Seconds 30
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
Start-Sleep -Seconds 2
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
Start-Sleep -Seconds 2
#[System.Windows.Forms.SendKeys]::SendWait("{DOWN 1}")
Start-Sleep -Seconds 1
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")