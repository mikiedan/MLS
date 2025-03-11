$bootdrive = get-disk | Where-Object {$_.Number -eq '0'} | Select-Object -ExpandProperty Number


$partition = Get-Partition -DiskNumber $bootdrive | Where-Object {$_.Size -ge '150GB'} | Select-Object -ExpandProperty PartitionNumber


Dism /Mount-Image /ImageFile:"C:\WinPE_amd64\media\sources\boot.wim" /Index:1 /MountDir:"C:\WinPE_amd64\mount"



Dism /Mount-Image /ImageFile:"E:\boot.wim" /Index:1 /MountDir:"C:\mount"




$Partitions = Get-Partition -DiskNumber 0
$Partitions | ForEach-Object { Get-Volume -Partition $_ }

Initialize-Disk -Number 0 -PartitionStyle GPT

get-disk -Number 0 | Get-Partition


New-Partition -DiskNumber 0 -Size 512MB -GptType "{EBD0A0A2-B9E5-4433-87C0-68B6B72699C7}" | Format-Volume -FileSystem FAT32 -NewFileSystemLabel "EFI" -Confirm:$false




