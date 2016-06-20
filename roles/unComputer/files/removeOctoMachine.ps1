param($machineName)

Import-Module Octopus-Cmdlets
$apiKey = 'API-FJSE2MH6VBBBBBBBBGKTKY'
$baseUrl = 'http://octopusserver:8090/'

Connect-OctoServer $baseUrl $apiKey
# The machine name that will be in the scopes of what we want to delete/modify
$machine = Get-OctoMachine -Name $machineName
# get the ID of the machine
$ider =  $machine.Id
$uri = $baseUrl + '/api/machines/' + $ider

# do stuff to the machine
#Invoke-RestMethod -Uri $uri -Method Get -Header @{ "x-Octopus-ApiKey" = $apiKey }
Invoke-RestMethod -Uri $uri -Method DELETE -Header @{ "x-Octopus-ApiKey" = $apiKey }
