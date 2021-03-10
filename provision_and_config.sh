#!/bin/bash

echo "Making sure terraform has been initialized..."
terraform init 
echo ""
echo "Running terraform to create VMs in AWS..."
terraform apply -auto-approve
echo ""
echo "Waiting (20 seconds) to make sure VMs are all initialized and available..."
sleep 20
echo ""
echo "Running Ansble playbook to configure loadbalancer and web servers..."
ansible-playbook playbooks/all-playbooks.yml
echo ""
echo "Connect to urls to test:"
terraform output website_lb
terraform output website_test_lb