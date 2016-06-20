#!/bin/bash
powerOnTimeout='75'
vmtemplateWin=$2
#vmtemplateWin="DOTPL-W12r2S14-vlan60"
machineName=$1
vcenter_hostname=$3
baseDir='/usr/ansible/playbooks' 

if [ $vcenter_hostname == 'vsphere01.contoso.local' ]
 then
  cluster_name=QA_DEV
  datacenter_name=NA
  esx_hostname=NA
  vsphere_vars_file=../group_vars/vsphere.yml
  vcenter_hostname=vsphere01.contoso.local
  newMask=24
  newGateway=11.119.6.1
  newDNS1=11.119.6.10
  newDNS2=11.119.188.12
  subnet=11.119.6.0
elif [ $vcenter_hostname == 'drvc01.contoso.local' ]
 then
  vsphere_vars_file=../group_vars/drvc01.yml
  cluster_name=NA
  datacenter_name=DisasterRecovery
  esx_hostname=dresxhost01.contoso.local
  vcenter_hostname=drvc01.contoso.local
  newMask=24
  newGateway=192.168.82.1
  newDNS1=192.168.82.100
  newDNS2=11.119.188.12
  subnet=192.168.82.0
else
  echo "Must provide vcenter hostname. Exiting."
  exit 1
fi


pushd $basedir

declare -a commands=(
                        "/usr/bin/ansible-playbook \
                           -e machineName=$machineName \
                           -e powerOnTimeout=$powerOnTimeout \
                           -e vmtemplate=$vmtemplateWin \
                           -e cluster_name=$cluster_name \
                           -e vsphere_vars_file=$vsphere_vars_file \
                           -e esx_hostname=$esx_hostname \
                           -e datacenter_name=$datacenter_name \
                           $baseDir/cloner.yml \
                           --vault-password-file \
                           $baseDir/pass.txt -vv"
                        "/usr/bin/ansible-playbook \
                           -e machineName=$machineName \
                           -e subnet=$subnet \
                           $baseDir/claimIpfreely.yml \
                           --private-key=$key \
                           --vault-password-file \
                           $baseDir/pass.txt -vv"
                        "/usr/bin/ansible-playbook \
                           -e machineName=$machineName \
                           -e newMask=$newMask \
                           -e newGateway=$newGateway \
                           -e newDNS1=$newDNS1 \
                           -e newDNS2=$newDNS2 \
                           -e powerOnTimeout=$powerOnTimeout \
                           -e subnet=$subnet
                           $baseDir/windowsProvisionStatic.yml \
                           --private-key=$key \
                           --vault-password-file \
                           $baseDir/pass.txt -vv"
                        "/usr/bin/ansible-playbook \
                           -e machineName=$machineName \
                           $baseDir/windowsProvision.yml \
                           --vault-password-file \
                           $baseDir/pass.txt -vv"
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

