$domainfqdn = $env:USERDNSDOMAIN
$Service = 'svc-ecmadmin'

#Get Enviroment hash table 
$Whatdomain =     @{'Dev' =             @{      'MECM'        = 'C2AC00111'
                                                'SQLAC'     = 'C2AC00105'
                                                'SiteCode'  = 'DET'
                                                'domain'  = 'appt.local'
                                                'DBName' = 'CM_DET'
                                                'InstName' = 'MSSQLServer'
                                                'Prefix' = 'Appt\'
                                        }
                    'Test' =            @{      'MECM' = 'C1AC00111'
                                                'SQLAC'     = 'C1AC00105'
                                                'SiteCode'  = 'TSL'
                                                'domain'  = 'test.local'
                                                'DBName' = 'CM_TSL'
                                                'InstName' = 'MSSQLServer'
                                                'Prefix' = 'Test\'
                                        }
                    'Preprod' =         @{      'MECM' = 'C3AC00111'
                                                'SQLAC'     = 'C3AC00105'
                                                'SiteCode'  = 'DET'
                                                'domain'  = 'Pret.local'
                                                'DBName' = 'CM_DET'
                                                'InstName' = 'MSSQLServer'
                                                'Prefix' = 'Pret\'
                                        }
                    'Production' =      @{      'MECM' = 'C10AC00111'
                                                'SQLAC'     = 'C3AC00105'
                                                'SiteCode'  = 'DET'
                                                'domain'  = 'Pret.local'
                                                'DBName' = 'CM_DET'
                                                'InstName' = 'MSSQLServer'
                                                'Prefix' = 'Pret\'
                                    }
                    }
  
 
#Non Production Tag info
If ($domainfqdn -eq 'appt.local') 
    {
    $SiteCodevar = $Whatdomain.Dev.SiteCode
    $ProviderMachineNamevar = $Whatdomain.Dev.MECM + '.' + $Whatdomain.Dev.domain
    $SitesystemDBvar = $Whatdomain.Dev.SQLAC + '.' + $Whatdomain.Dev.domain
    $DBservervar = $Whatdomain.Dev.DBName
    $DBInstancevar = $Whatdomain.Dev.InstName
    $Servicevar = $Whatdomain.Dev.Prefix + $Service
    }
elseif ($domainfqdn -eq 'Test.local') 
    {
    $SiteCodevar = $Whatdomain.Test.SiteCode
    $ProviderMachineNamevar = $Whatdomain.Test.MECM + '.' + $Whatdomain.Test.domain
    $SitesystemDBvar = $Whatdomain.Test.SQLAC + '.' + $Whatdomain.Test.domain
    $DBservervar = $Whatdomain.Test.DBName
    $DBInstancevar = $Whatdomain.Test.InstName
    $Servicevar = $Whatdomain.Test.Prefix + $Service
    }
elseif ($domainfqdn -eq 'Pret.local') 
    {
    $SiteCodevar = $Whatdomain.PreProd.SiteCode
    $ProviderMachineNamevar = $Whatdomain.PreProd.MECM + '.' + $Whatdomain.PreProd.domain
    $SitesystemDBvar = $Whatdomain.PreProd.SQLAC + '.' + $Whatdomain.PreProd.domain
    $DBservervar = $Whatdomain.PreProd.DBName
    $DBInstancevar = $Whatdomain.PreProd.InstName
    $Servicevar = $Whatdomain.PreProd.Prefix + $Service
    } 
elseif ($domainfqdn -eq 'Cycitplatprod.local') 
    {
    $SiteCodevar = $Whatdomain.Production.SiteCode
    $ProviderMachineNamevar = $Whatdomain.Production.MECM + '.' + $Whatdomain.Production.domain
    $SitesystemDBvar = $Whatdomain.Production.SQLAC + '.' + $Whatdomain.Production.domain
    $DBservervar = $Whatdomain.Production.DBName
    $DBInstancevar = $Whatdomain.Production.InstName
    $Servicevar = $Whatdomain.Production.Prefix + $Service 
    }                   

                    $SiteCode = $SiteCodevar # Site code 
                    $ProviderMachineName = $ProviderMachineNamevar # SMS Provider machine name
                    
                    # Customizations
                    $initParams = @{}
                    
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
Set-Location "$($SiteCode):\" @initParams

# Add the Reporting Service Point role to the site
Add-CMReportingServicePoint -SiteCode $SiteCode -SiteSystemServerName $SitesystemDBvar -DatabaseServerName $SitesystemDBvar -DatabaseName $DBservervar -ReportServerInstance $DBInstancevar -UserName $Servicevar
