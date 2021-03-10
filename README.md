# Create and deploy an Apache LB and two Apache web hosts

Uses Terraform to deplploy three identical EC2 instances
Terraform will dynamically generate an Ansible inventory file 'host-dev'
It will also dynamically create an SSH keypair and place the private key in this directory.

Once all three instances have been deploployed, run the Ansible playbook
'playbooks/all-playbooks.yml'

command: 'ansible-playbook playbooks/all-playbooks.yml'

Ansible will update and install Apache on all server and configure the first host to be
a loadbalancer. The other two servers will host a web page that is accessed through the 
loadbalancer.

enter the IP address of the LB to see the main webpage

To test out loadbalancer, add /info.pho to the end of the IP address, and refresh to see
loadbalancing in action... exiting!!!

http://<lb IP address>/info.php


Some adhoc commands:
ansible -m ping all
ansible -m shell -a "uname" webservers:loadbalancers
ansible -m shell -a "uname" all 

Module Index:
https://docs.ansible.com/ansible/2.9/modules/modules_by_category.html

playbooks commands:
ansible-playbook playbooks/ping.yml
ansible-playbook playbooks/uname.yml
ansible-playbook playbooks/yum-update.yml
ansible-playbook playbooks/yum-update.yml 
ansible-playbook playbooks/setup-lb.yml



ansible -m setup app1  (get variable info on a system)

ansible -m setup app1 | grep ansible_hostname
        "ansible_hostname": "ip-172-31-1-131",

ansible -m setup webservers | grep ansible_hostname
        "ansible_hostname": "ip-172-31-1-131",
        "ansible_hostname": "ip-172-31-3-65",



check mode
ansible-playbook playbooks/setup-app.yml --check
