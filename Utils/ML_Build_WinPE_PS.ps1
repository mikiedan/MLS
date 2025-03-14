#Mount the WinPE boot.wim file ready to inject required powershell cmdlets
Mount-WindowsImage -ImagePath 'C:\bootwinpe\media\sources\boot.wim' -Index:1 -Path 'C:\bootwinpe\mount'

#Add location of additional component as a variable 
$WinADK="C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs"

#Mount wim file into a temp folder prior to adding any additional packages or drivers to the image
$WinPETemp='C:\bootwinpe\mount'

#Load the required cab files into an array
$CABfiles = @("$WinADK\en-gb\WinPE-WMI_en-gb.cab","$WinADK\en-gb\WinPE-NetFX_en-gb.cab", "$WinADK\en-gb\WinPE-Scripting_en-gb.cab","$WinADK\en-gb\WinPE-PowerShell_en-gb.cab","$WinADK\en-gb\WinPE-StorageWMI_en-gb.cab", "$WinADK\en-gb\WinPE-DismCmdlets_en-gb.cab")

#For each cab file load into the mounted image file
Foreach ($CABfile in $CABfiles) {
  Add-WindowsPackage -PackagePath $CABFile -Path $WinPETemp 
}

#Once all cab or driver files loaded save and dismount the image from the temp location.
Dismount-WindowsImage -path $WinPETemp -commit
