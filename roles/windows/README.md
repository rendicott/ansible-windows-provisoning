windows
=========

Runs standard scripts against a Windows target to do things like rename machine and join domain. 

Requirements
------------

NA


Role Variables
--------------

Need to specify which step to run by passing in one of the following:

    step: one
    step: two
    step: three

Needs the following additional variables

    machineName: MYHOSTNAME
    vsphere_login: usernametojoindomain 
    vsphere_password: passwordforaboveuser
    project_name: canbeusedasaswitchcaseforOUspecification


Dependencies
------------

Depends on the pySser inventory script which can be foun here: (https://github.com/rendicott/pySser)

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - name: create VM
      hosts: 127.0.0.1
      gather_facts: false
      connection: local
      vars_files:
        - "{{ vsphere_vars_file }}"
        - '../group_vars/general.yml'
      vars:
        - powerOnTimeout: 120 
        - ansible_os_family: Windows
        - vmtemplate: tplW12r2S14
      roles: 
       - cloneVm
License
-------

BSD

Author Information
------------------

rendicott and chris

NOTES
------------------
This is our default folder structure for an ansible role. Try to follow this please love chris. 

If we want to add a new role copy then entire folder structure and go from there pls

This role performs the following tasks:
-Clones VM from template {{ vmtemplate }} stored in ../../group_vars/vsphere.yml
-places it in the QA_DEV cluster in resource pool /Resources
-after the machine boots it connects to vmware-tools to get the IP
-adds the host/ip to the ipfreely
-after that the machine can be referenced with "{{ inventory_hostname }}"
