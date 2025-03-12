#Find installed Disk 0 which is on the primary bus
$bootdrive = get-disk | Where-Object {$_.Number -eq '0'} | Select-Object -ExpandProperty Number


#Find the primary partition and this typically is the largest in size
$partition = Get-Partition -DiskNumber $bootdrive | Where-Object {$_.Size -ge '150GB'} | Select-Object -ExpandProperty PartitionNumber


Dism /Mount-Image /ImageFile:"C:\WinPE_amd64\media\sources\boot.wim" /Index:1 /MountDir:"C:\WinPE_amd64\mount"



Dism /Mount-Image /ImageFile:"E:\boot.wim" /Index:1 /MountDir:"C:\mount"



