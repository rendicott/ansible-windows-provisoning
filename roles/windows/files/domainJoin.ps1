param($username, $password, $projectName) 

try
{
	if (!$projectName) {
	    $projectName = 'idontcare'
	}

	if($projectName -eq "BFF") 
	{
		$path = 'OU=BFFServers,OU=SBSServers,OU=Computers,OU=MyBusiness,DC=cl,DC=local'
	}
	else
	{
		$path = 'OU=QAServers,OU=SBSServers,OU=Computers,OU=MyBusiness,DC=cl,DC=local'
	}
	$secPass = ConvertTo-SecureString $password -AsPlainText -Force
	$credential = New-Object System.Management.Automation.PSCredential($username, $secPass)

	Add-Computer  -ComputerName $ENV:COMPUTERNAME -Credential $credential -OUPath $path -DomainName cl.local
}
catch
{
	Write-Host "Failed to join domain"
	Write-Host $_
	return -1
}