Role Name
=========

Sets a static IP on a windows machine.

Requirements
------------

NA

Role Variables
--------------

Requires two variables. For example:
    
    oldIp: 10.119.88.224
    newIp: 10.119.88.10

Dependencies
------------

NA

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:


    ### the cdl_ansible_newaddr variable comes from claiming an IP via the claimIpfreely.yml playbook
    - name: set static ip Windows
      connection: smart
      gather_facts: true
      hosts: "{{ machineName }}"
      vars_files:
        - '../group_vars/windows.yml'
        - "{{ vsphere_vars_file }}"
        - '../group_vars/general.yml'
      vars:
        - newIp: "{{ cdl_ansible_newaddr }}"
        - oldIp: "{{ inventory_hostname }}"
      roles:
        - windowsStaticIp

    - name: update inventory with new IP and delete old IP
      hosts: 127.0.0.1
      gather_facts: false
      connection: local
      vars_files:
        - '../group_vars/general.yml'
      vars: 
        - ips: "{{ groups[machineName] }}"
        - newip: "{% for host in groups[machineName] %}{{ hostvars[host]['cdl_ansible_newaddr'] }}{% endfor %}"
      tasks:
        - name: debug oldip
          debug: msg="var 'ips' contains '{{ item }}'"
          with_items:
            - "{{ ips }}"

        - name: debug newip
          debug: msg="var 'newip' = '{{ newip }}'"

        - name: pause for a few seconds to wait for interface to come back up
          pause: seconds=15

        - name: test ping newip
          command: ping "{{ newip }}" -c 1
          register: pingresult

        - name: release old DHCP IP by modifying it
          command: "{{ansible_hosts_file}} --modifyip {{ item }}:DHCP --filtersubnet {{ subnet }} --capsv 'cdl_isprod:1|cdl_autodelete:0|cdl_dhcp:1|cdl_ansible_ignore:0|cdl_ansible_newaddr:none'"
          with_items:
            - "{{ ips }}"

        - name: modify new IP registration and make it visible to ansible
          command: "{{ansible_hosts_file}} --modifyip {{ newip }}:{{ machineName }} --filtersubnet {{ subnet }} --capsv 'cdl_isprod:0|cdl_autodelete:1|cdl_dhcp:0|cdl_ansible_ignore:0|cdl_ansible_newaddr:none'"
 

License
-------

BSD

Author Information
------------------

rendicott
