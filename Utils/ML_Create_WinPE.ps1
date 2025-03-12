Run Deployment and Imaging Tool cmd
#Run the command to extract WinpE files into C:\WinPE_amd
copype amd64 C:\WinPE_MLFiles

#Run the following to mount the image to add files,drivers etc
Dism /Mount-Image /ImageFile:C:\WinPE_MLFiles\media\sources\boot.wim /Index:1 /MountDir:C:\WinPE_MLFiles\mount







#Once changes have been made dismount and Commit or Discard
Dism /Unmount-Image /MountDir:C:\WinPE_MLFiles\mount /Discard

