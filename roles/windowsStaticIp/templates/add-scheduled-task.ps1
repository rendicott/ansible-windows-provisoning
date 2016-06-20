# Creates a scheduled task to run once
# the script in secondsFromNow
#
#
$secondsFromNow = 15
$workdir = "C:\temp\"
$script = ".\windows-set-static-ip.ps1"

$user = "{{ ansible_ssh_user }}"
$pass = "{{ ansible_ssh_pass }}"
$t = (get-date).addseconds($secondsFromNow)
$action = new-scheduledtaskaction -execute 'Powershell.exe' -WorkingDirectory $workdir -Argument "-WindowStyle Hidden -file $script"
$principal = new-scheduledtaskprincipal -userid '.\administrator' -runlevel highest
$trigger = new-scheduledtasktrigger -once -at $t
$task = new-scheduledtask -action $action -trigger $trigger -principal $principal
register-scheduledtask -action $action -trigger $trigger -user "$env:USERDOMAIN\$user" -password "$pass" -runlevel highest -TaskName "set static ip" -Description "One time action to set static ip"


