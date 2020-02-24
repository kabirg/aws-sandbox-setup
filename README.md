# aws-sandbox-setup

A terraform stack to spin up a simple VPC environment and small EC2 instance for sandbox testing.

This project also comes with a Python script to manage the EC2 instance state for cost-management purposes.


## aws_powercycle.py

Script to stop/start instances.
The script will wait for the instance to fully stop (or fully start/initialize) before completing and sending a completion message to the user.

Example command to stop an instance:
`python3 aws_powercycle.py stop <INSTANCE_ID>`

Example command to start an instance:
`python3 aws_powercycle.py start <INSTANCE_ID>`


## account_bootstrap

Run `terraform apply` within the root directory to spin up the VPC quickly.

Modify the `variables.tf` file with custom values as desired before provisioning the stack.

This configuration is modularized. The `minimal_module` directory provisions the exact same resources, except it's all condensed into a single script.
