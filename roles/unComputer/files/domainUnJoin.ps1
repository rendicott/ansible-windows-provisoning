param($username, $password) 

Import-Module ServerManager
Add-WindowsFeature RSAT-AD-PowerShell

Import-Module ActiveDirectory

try
{
    $secPass = ConvertTo-SecureString $password -AsPlainText -Force    
    $credential = New-Object System.Management.Automation.PSCredential($username, $secPass)
    Remove-ADComputer -Credential $credential -Identity $ENV:COMPUTERNAME  -Confirm:$False
}
catch
{
    Write-Host "Failed to unjoin domain"
    Write-Host $_
    return -1
}

