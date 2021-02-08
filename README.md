Stack name: AnsibleCourseStack
Key Name
NameOfService: ansible-instances
LnPublicIpAddressInstance1	3.226.90.212	
LnPublicIpAddressInstance2	18.206.4.126	
LnPublicIpAddressLoadBalancer	52.70.9.27

ssh -i "~/key/ansible-course-key-pair.pem" ec2-user@3.226.90.212
ssh -i "~/key/ansible-course-key-pair.pem" ec2-user@18.206.4.126
ssh -i "~/key/ansible-course-key-pair.pem" ec2-user@52.70.9.27

Some adhoc commands:
ansible -m ping all
ansible -m shell -a "uname" webservers:loadbalancers
ansible -m shell -a "uname" all 

Module Index:
https://docs.ansible.com/ansible/2.9/modules/modules_by_category.html

playbook commands:
ansible-playbook playbooks/ping.yml
ansible-playbook playbooks/uname.yml
ansible-playbook playbooks/yum-update.yml

ansible-playbook playbooks/yum-update.yml 

ansible-playbook playbooks/setup-lb.yml
http://<lb IP address>
http://<lb IP address>/balancer-manager


ansible -m setup app1  (get variable info on a system)

ansible -m setup app1 | grep ansible_hostname
        "ansible_hostname": "ip-172-31-1-131",

ansible -m setup webservers | grep ansible_hostname
        "ansible_hostname": "ip-172-31-1-131",
        "ansible_hostname": "ip-172-31-3-65",

http://<lb IP address>/info.php