$domainfqdn = $env:USERDNSDOMAIN
$domainfqdn = 'test.local'

#Get Enviroment hash table 
$Whatdomain =     @{'Dev' =          @{'MECM'        = 'C2AC00111'
                                                'SQLAC'     = 'C2AC00105'
                                                'SiteCode'  = 'DET'
                                                'domain'  = 'appt.local'
                                        }
                    'Test' =          @{'MECM' = 'C1AC00111'
                                                'SQLAC'     = 'C2AC00105'
                                                'SiteCode'  = 'TSL'
                                                'domain'  = 'test.local'
                                        }
                    'pret.local' =          @{'MECM' = 'C3AC00111'
                                        }
                    'cycitplatprod.local' = @{'MECM' = 'C10AC00111'
                                    }
                    }
  
 
#Non Production Tag info
If ($domainfqdn -eq 'appt.local') 
    {
    $SiteCodevar = $Whatdomain.'Dev'.SiteCode
    $ProviderMachineNamevar = $Whatdomain.'Dev'.MECM + '.' + $Whatdomain.'Dev'.domain
    
    }
elseif ($domainfqdn -eq 'test.local') 
    {
    $SiteCodevar = $Whatdomain.'Test'.SiteCode
    $ProviderMachineNamevar = $Whatdomain.'Test'.MECM + '.' + $Whatdomain.'Test'.domain
}                    

                    $SiteCode = $SiteCodevar # Site code 
                    $ProviderMachineName = $ProviderMachineNamevar # SMS Provider machine name
                    
                    # Customizations
                    #$initParams = @{}
                    #$initParams.Add("Verbose", $true) # Uncomment this line to enable verbose logging
                    #$initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors
                    
                    # Do not change anything below this line
                    
                    # Import the ConfigurationManager.psd1 module 
                    if((Get-Module ConfigurationManager) -eq $null) {
                        Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
                    }
# Connect to the site's drive if it is not already present
if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

# Set the current location to be the site code.
Set-Location "$($SiteCode):\" #@initParams


Add-CMReportingServicePoint -SiteCode $SiteCode -SiteSystemServerName "YourServerName" -DatabaseServerName "YourDatabaseServerName" -DatabaseName "YourDatabaseName" -ReportServerInstance "YourReportServerInstance"
