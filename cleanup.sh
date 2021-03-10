#!/bin/bash

echo "Running terraform to delete VMs in AWS (with prompt)..."
echo ""
terraform destroy
echo ""
echo "Deleting hosts-dev.."
rm ./hosts-dev