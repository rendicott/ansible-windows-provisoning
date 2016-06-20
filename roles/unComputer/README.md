Role Name
=========

Removes the windows box from the domain and has scripts to delete the computer and variables from an Octopus environment

Requirements
------------

NA

Role Variables
--------------

various variables for octopus server access and project. Need to pass in variables for windows domain so it can drop from the domain. 

Dependencies
------------

The `domainUnJoin.ps1` script will need the `Add-WindowsFeature RSAT-AD-PowerShell` command to work. 

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - name: Remove computer from domain and Octopus
      hosts: "{{ machineName  }}"
      gather_facts: false
      connection: smart
      vars_files:
        - '{{ vsphere_vars_file  }}'
        - '../group_vars/creds.yml'
        - '../group_vars/general.yml'
        - '../group_vars/windows.yml'
      roles:
        - unComputer


License
-------

BSD

Author Information
------------------

rendicott