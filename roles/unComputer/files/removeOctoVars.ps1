param([string]$machineName) 

install-module Octopus-Cmdlets

Import-Module Octopus-Cmdlets

Connect-OctoServer http://octopusserver:8090/ API-FJSE2MHBBBBBBBBDUGKTKY
# The machine name that will be in the scopes of what we want to delete/modify
#$machineName = "DODAMMIT"

if($machineName)
{

	$projects = get-octoproject
	foreach ($project in $projects)
	{ # loop through all projects
		$vars = Get-OctoVariable -Project $project.name
		foreach ($var in  $vars) 
		{ # loop through all variables in all projects
			if ($var.Breadth -eq $machineName) 
			{ # if the machine name we want to get rid of shows up in scopes
				if ($var.Breadth.count -gt 1) 
				{ # first check to see if there are other scopes in this variable
					$Collection = {$var.Breadth}.Invoke()
					$Collection.Remove($machineName)
					$stringer = $Collection -join ' '
					# If so remove the machineName from the scope and create a new variable
					Add-OctoVariable -Project $project.name -Name $var.name -Value $var.Value -Environments $var.Environment -Roles $var.Role -Machines $stringer
				}      

				if ($var.Breadth -eq $machineName) {
					# modify all variables with our machineName in the scope 
					Update-OctoVariable -Project $project.name -Name 'DELETEMEIMSTUPID' -Id $var.id -Value $var.value
				}
			}
		}
		# delete all variables in this project with the fake name we gave
		Remove-OctoVariable -Project $project.name -Name "DELETEMEIMSTUPID"
	}

}
else
{
	write-host "machineName must not be empty"
	exit 1

}