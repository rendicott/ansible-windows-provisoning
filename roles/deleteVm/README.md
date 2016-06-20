Role Name
=========

Deletes the machine from vSphere if certain attributes are set in the phpIpam inventory. 

Requirements
------------

phpIpam inventory

Role Variables
--------------

TBD

Dependencies
------------

NA

Example Playbook
----------------

    - name: Delete VM
      hosts: localhost
      gather_facts: false
      connection: local
      vars_files:
        - "{{ vsphere_vars_file }}"
        - '../group_vars/creds.yml'
        - '../group_vars/general.yml'
      vars:
        - cdl_autodelete: "{% for host in groups[machineName] %}{{hostvars[host].cdl_autodelete}}{% endfor %}"
        - ips: "{{ groups[machineName] }}"
      roles:
        - deleteVm

License
-------

BSD

Author Information
------------------

rendicott
