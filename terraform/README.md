# Infrastructre setup

## EC2 clusters
- We use a custom module comprising of ALB mdule and ASG module to provision `nginx` and `app` clusters
- By default the cluster provisons 2 instances in the ASG with an LB associated with it

## Postgres Aurora
- Postgres aurora is provisioned using default terraform module

## VPN
- We use openVPN AMI to provison a VPN
- This currently doesnt have an EIP but an EIP and domain can be attached to it
- We add user-data script to disable interactive VPN config and automate it
- The configuration was done manually using UI however puppet can be leveraged to add users and automate it as well