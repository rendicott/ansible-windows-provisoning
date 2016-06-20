Import-Module Octopus-Cmdlets

Connect-OctoServer http://octopusserver:8090/ API-FJSE2MHBBBBBBBBBBBBBTKY

Add-OctoVariable -Project BFF -Name Bff -Value "Data Source=$env:COMPUTERNAME;Initial Catalog=BFF;Persist Security Info=True;User ID=sa;Password=p4ssw0rd;MultipleActiveResultSets=True" -Machines "$env:COMPUTERNAME"
                   


