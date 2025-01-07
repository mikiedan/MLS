#Connect-AzAccount -SubscriptionId '2433ca04-f4eb-4040-a5ee-0dac9b2c7e30' 
#Get-AzContext -ListAvailable
#Set-AzContext -Subscription 'Serco OMC Lab'
#Disconnect-AzAccount

Connect-AzAccount -Tenant '018caec8-2092-4b00-9e0c-7f942104fdf6' -SubscriptionId '2433ca04-f4eb-4040-a5ee-0dac9b2c7e30'
Set-AzDefault -ResourceGroupName MichaelLauLab


#az account --Tenant 'Serco OMC Lab' --SubscriptionId '2433ca04-f4eb-4040-a5ee-0dac9b2c7e30'