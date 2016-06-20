# Ansible Windows Provisioning

Example scripts, playbooks, and roles for 'one-click' Windows VM creation from VMWare templates on vSphere. 

## Features
* Static IP provisioning from an external database (phpIpam)
* Bootstrap with DHCP then sets static on the Windows VM
* Machine rename and domain join to specific OU
* Supports multiple vSphere host with a selectable switch
* Basic software installation via Chocolatey (infinitely expandable)
* Full cleanup deletion process
* Designed with Rundeck in mind as GUI for building the script parameters and execution of the script. 

Go through the following files and modify for your environment:

* ./group_vars/general.yml (path to Ansible inventory script. This example uses pySser and phpIpam for inventory https://github.com/rendicott/pySser )
* ./group_vars/vsphere.yml (credentials to talk to vsphere and clone vms)
* ./group_vars/windows.yml (local admin credentials for the windows template)
* ./rundeck-jobscripts/createvm-windows.sh (change switch cases for vsphere hosts and IPs to match environment)
* you might have to go through some of the playbooks/roles to track down some variables (sorry)

Then you can 
    ./rundeck-jobscripts/createvm-windows.sh MYMACHINE DOTPL-W12r2S14 vsphere01.contoso.local

To delete the vm you can run
    ./rundeck-jobscripts/deletevm-windows.sh MYMACHINE vsphere01.contoso.local
