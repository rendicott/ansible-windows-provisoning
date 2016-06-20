#!/bin/bash
baseDir='/usr/ansible/playbooks'
pushd $baseDir 
machineName=$1
vcenter_hostname=$2

if [ $vcenter_hostname == 'vsphere01.contoso.local' ]
 then
  vsphere_vars_file=../group_vars/vsphere.yml
elif [ $vcenter_hostname == 'drvc01.contoso.local' ]
 then
  vsphere_vars_file=../group_vars/drvc01.yml
else
  echo "Must provide vcenter hostname. Exiting."
  exit 1
fi

declare -a commands=(
                        "/usr/bin/ansible-playbook \
                          -e machineName=$machineName \
                          -e vsphere_vars_file=$vsphere_vars_file \
                          $baseDir/unComputer.yml \
                          --vault-password-file $baseDir/pass.txt -vv"
			"/usr/bin/ansible-playbook \
                          -e vsphere_vars_file=$vsphere_vars_file \
                          -e machineName=$machineName \
                          $baseDir/deleteVm.yml \
                          --vault-password-file $baseDir/pass.txt -vv"
                    )


for command in "${commands[@]}"
  do
    echo helo
   $command
        if [ "$?" -ne "0" ]
        then
                echo "error running playbook"
                exit -1
        fi

done

