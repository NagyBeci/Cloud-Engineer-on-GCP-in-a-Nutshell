# Introduction
In this guide, you'll learn about **Terraform modules**—what they are, how to use modules from the Terraform Registry, and how to build your own. By the end, you'll know how to structure and version-control modules to create reusable, scalable infrastructure configurations in Google Cloud.

# Terraform Modules: Overview and Best Practices

## What is a Terraform Module?
A **Terraform module** is a set of one or more configuration files in a single directory.  
- **Root Module**: When you run Terraform commands in a directory containing `.tf` files, that directory is treated as the root module.  
- **Child Modules**: A configuration can reference modules stored in other directories or remote sources via `module` blocks.

### Local vs. Remote Modules
- **Local**: Sourced from your local file system (e.g., `source = "./modules/my-module"`).  
- **Remote**: Sourced from the Terraform Registry, version control, or HTTP URLs.

### Module Best Practices
1. **Plan for Modules**: Even small configurations benefit from modular design.  
2. **Use Local Modules**: Organize and encapsulate configurations for easier maintenance.  
3. **Use Public Registry**: Quickly implement functionality by leveraging community modules.  
4. **Publish & Share**: Encourage collaboration by sharing modules within your organization or publicly.

---

## Task 1: Use Modules from the Registry

1. **Clone an Example Module**  
   ```bash
   git clone https://github.com/terraform-google-modules/terraform-google-network
   cd terraform-google-network
   git checkout tags/v6.0.1 -b v6.0.1
   cd examples/simple_project
   ```

2. **Inspect `main.tf`**  
   - A `module "test-vpc-module"` block references the Google Cloud network module from the registry.
   - Required variables (e.g., `network_name`, `project_id`, `subnets`) are passed in.

3. **Set Module Input Variables**  
   - **`variables.tf`**:
     ```hcl
     variable "project_id" {
       default = "YOUR_PROJECT_ID"
     }
     variable "network_name" {
       default = "example-vpc"
     }
     ```
   - **`main.tf`**:
     ```hcl
     module "test-vpc-module" {
       ...
       project_id   = var.project_id
       network_name = var.network_name
       ...
     }
     ```
   - Update subnet regions to `us-east4` (or your allowed region).

4. **Provision Infrastructure**
   ```bash
   terraform init
   terraform apply
   # Type "yes" at prompt
   ```

5. **Cleanup**
   ```bash
   terraform destroy
   # Type "yes"
   rm -rf ~/terraform-google-network
   ```

---

## Task 2: Build Your Own Module

### Module Structure
- **`LICENSE`**: License under which you share the module.  
- **`README.md`**: Documentation in Markdown.  
- **`main.tf` / `website.tf`** (or any `.tf`): Main Terraform config.  
- **`variables.tf`**: Input variable definitions.  
- **`outputs.tf`**: Output definitions for referencing outside the module.  

(You do **not** check in `.terraform/` or `terraform.tfstate` files to source control.)

### Example: GCS Static Website Module

1. **Create Directories and Files**
   ```bash
   mkdir -p ~/modules/gcs-static-website-bucket
   cd ~/modules/gcs-static-website-bucket
   touch website.tf variables.tf outputs.tf README.md LICENSE
   ```
2. **`website.tf`**:  
   ```hcl
   resource "google_storage_bucket" "bucket" {
     name    = var.name
     project = var.project_id
     ...
     # Additional config for versioning, lifecycle rules, encryption, etc.
   }
   ```
3. **`variables.tf`**:  
   ```hcl
   variable "name" {
     type        = string
     description = "The name of the bucket."
   }
   variable "project_id" {
     type        = string
     description = "The ID of the project to create the bucket in."
   }
   ...
   ```
4. **`outputs.tf`**:  
   ```hcl
   output "bucket" {
     description = "The created storage bucket"
     value       = google_storage_bucket.bucket
   }
   ```

### Calling Your Module
In the **root module** (e.g., `main.tf` in `~/`):
```hcl
module "gcs-static-website-bucket" {
  source    = "./modules/gcs-static-website-bucket"
  name      = var.name
  project_id = var.project_id
  location  = "us-east4"
  # Additional inputs like lifecycle_rules
}
```
Create **`variables.tf`** and **`outputs.tf`** in the root directory as needed:
```hcl
# variables.tf
variable "project_id" {
  default = "YOUR_PROJECT_ID"
}
variable "name" {
  default = "YOUR_UNIQUE_BUCKET_NAME"
}
```
```hcl
# outputs.tf
output "bucket-name" {
  value = module.gcs-static-website-bucket.bucket.name
}
```

### Provision and Validate
```bash
terraform init
terraform apply
# "yes" to confirm
```
Then upload files:
```bash
gsutil cp index.html gs://YOUR_UNIQUE_BUCKET_NAME
```
Visit `https://storage.cloud.google.com/YOUR_UNIQUE_BUCKET_NAME/index.html`

### Clean Up
```bash
terraform destroy
# "yes"
```

---

## Conclusion
You’ve learned how to **leverage modules from the Terraform Registry** and **build your own reusable Terraform modules** for Google Cloud resources. This approach promotes a more consistent, maintainable infrastructure as code practice. 
```