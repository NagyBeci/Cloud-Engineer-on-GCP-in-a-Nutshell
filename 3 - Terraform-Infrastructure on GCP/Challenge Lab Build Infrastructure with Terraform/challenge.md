# Terraform Lab Guide

## Overview
This guide explains the steps taken to manage GCP infrastructure using Terraform, including importing existing resources, configuring remote state, and using the Terraform Registry.

## Task 1: Initial Setup
1. Created the project structure with main.tf, variables.tf, and two module directories (instances and storage)
2. Set up variables for region (us-west1), zone (us-west1-a), and project_id in all variables.tf files
3. Configured the Google Provider in main.tf
4. Initialized Terraform

## Task 2: Importing Existing Instances
1. Located two pre-existing VM instances (tf-instance-1 and tf-instance-2) in GCP Console
2. Added instances module reference to main.tf
3. Created minimal instance configurations in instances.tf matching the existing VMs
4. Imported both instances using terraform import command
5. Applied changes to update instances in-place

## Task 3: Remote Backend Configuration
1. Created a storage bucket in the storage module
2. Added storage module reference to main.tf
3. Created the bucket using terraform apply
4. Configured the bucket as remote backend with prefix "terraform/state"
5. Reinitialized Terraform and migrated state to the new backend

## Task 4: Infrastructure Modifications
1. Modified both existing instances to use e2-standard-2 machine type
2. Added a third instance named tf-instance-485298
3. Applied changes to implement the modifications

## Task 5: Resource Destruction
1. Removed the third instance (tf-instance-485298) configuration
2. Applied changes to destroy only the removed instance

## Task 6: Network Module Implementation
1. Added the Google Network module from Terraform Registry
2. Configured VPC (tf-vpc-757680) with global routing
3. Created two subnets in us-west1 region
4. Connected tf-instance-1 to subnet-01
5. Connected tf-instance-2 to subnet-02

## Task 7: Firewall Configuration
1. Created firewall rule named tf-firewall
2. Configured rule to allow TCP port 80 traffic
3. Set source range to 0.0.0.0/0 for all incoming traffic
4. Applied changes to implement the firewall rule

## Important Notes
- Always use `terraform plan` before applying changes
- Be careful when importing existing resources
- For production environments, ensure all configuration arguments are properly set
- Back up any important data before making infrastructure changes
- Use lifecycle rules to prevent accidental resource destruction