$bootdrive = get-disk | Where-Object {$_.Number -eq '0'} | Select-Object -ExpandProperty Number

$partition = Get-Partition -DiskNumber $bootdrive | Where-Object {$_.Size -ge '150GB'} | Select-Object -ExpandProperty PartitionNumber


Dism /Mount-Image /ImageFile:"C:\WinPE_amd64\media\sources\boot.wim" /Index:1 /MountDir:"C:\WinPE_amd64\mount"



Dism /Mount-Image /ImageFile:"E:\boot.wim" /Index:1 /MountDir:"C:\mount"

DiskPart /s x:\windows\system32\CreatePartitions-uefi.txt
dism /apply-image /imagefile:l:\win-11-0125.wim /index:1 /applydir:c:

