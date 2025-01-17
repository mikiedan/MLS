#Get all AWs EC2 instances
$allaws = Get-ADComputer -Filter * -Properties Name,ipv4address |
    Where-Object {$_.Name -match '[C-c][0-9](\d|\w)+00[1-4][0-5][0-9]'} |
        Select-Object -ExpandProperty Name


# Loop through each server in the list
foreach ($srv in $allaws) 
{
    # Test if the server is reachable
    if (Test-Connection -ComputerName $srv -Count 1 -Quiet) 
    {
        # Execute the command on the remote server
        Invoke-Command -ComputerName $srv -ScriptBlock 
        {
            # Ensure the directory exists
            if (-not (Test-Path -Path "C:\microland\ml\time")) 
            {
                New-Item -Path "C:\microland\ml\time" -ItemType Directory
            }
            # Get the hostname and time service status
            hostname
            w32tm /query /status /verbose >> "C:\microland\ml\time\old_Time.txt"
        } 
    }
    else 
    {
        Write-Host "Server $srv is not reachable."
    }
}