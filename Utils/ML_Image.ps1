#Find installed Disk 0 which is on the primary bus
$bootdrive = get-disk | Where-Object {$_.Number -eq '0'} | Select-Object -ExpandProperty Number

#Find the primary partition and this typically is the largest in size
$partition = Get-Partition -DiskNumber $bootdrive | Where-Object {$_.Size -ge '150GB'} | Select-Object -ExpandProperty PartitionNumber

#Set the found partition to C
Set-Partition -DiskNumber $bootdrive -PartitionNumber $partition -NewDriveLetter 'C'

#Carry out quick format
format fs=ntfs /q

#Mount the image file xxx.wim and apply to assigned partition C
Dism /apply-image /imagefile:x:\temp\win-11-0125.wim /index:1 /applydir:c:
