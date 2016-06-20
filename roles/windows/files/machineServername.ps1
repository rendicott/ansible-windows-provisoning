param([String]$machineName,[String]$domain= “contoso.local”)

if([string]::IsNullOrEmpty($machineName))
{

    Write-Host "Usage: machineServername.ps1 $machineName='myMachine' <$domain='contoso.local'>"
    exit -1
}

Rename-Computer -NewName $machineName

Write-Host "The machine must be restarted before changes will take effect"

# vagrant is going to deal with shutting down now
# Write-Host "Shutting down"

# shutdown /r /t 1
