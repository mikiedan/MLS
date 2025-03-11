$diskpartcmds = @"
select disk 0
clean
convert gpt
create partition efi size=512
format fs=fat32
assign letter=Z
create partition primary
format fs=ntfs quick
assign letter=G
"@

# Save the commands to a temporary text file
$tempFile = "X:\TEMP\diskpartScript.txt"
$diskpartcmds | Out-File -FilePath $tempFile -Encoding ASCII

# Run diskpart with the script file
Start-Process -FilePath "diskpart.exe" -ArgumentList "/s $tempFile" -Wait -NoNewWindow

# Remove the temporary file after execution
#Remove-Item -Path $tempFile

#Apply Image to partition G
Dism /apply-image /imagefile:X:\temp\win-11-0125.wim /index:1 /applydir:G:

#RunBCDboot
bcdboot G:\Windows /s Z: /f UEFI