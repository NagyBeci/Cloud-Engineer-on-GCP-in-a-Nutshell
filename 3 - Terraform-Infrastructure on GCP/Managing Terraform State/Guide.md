# Introduction
In this guide, you’ll learn about **Terraform state**—what it is, why it’s essential, and how to manage it. You’ll also explore **backends** (where state is stored) and their impact on performance, collaboration, and security. Finally, you’ll discover how to **import existing resources** into Terraform to bring them under Terraform’s control.

# Terraform State, Backends, and Imports

## Why Terraform Needs State
- **Mapping to Real World**: Terraform must map resource blocks in configuration to actual remote objects (e.g., Google Cloud resources).
- **Metadata**: State tracks dependencies and other metadata so Terraform knows the correct order to create/destroy resources.
- **Performance**: Terraform caches resource attributes in state to avoid querying large infrastructures repeatedly.
- **Collaboration**: Storing state remotely (e.g., in Cloud Storage) and locking it prevents corruption when multiple team members run Terraform simultaneously.

---

## Task 1: Working with Backends

### What are Backends?
- **Definition**: Control how Terraform loads state and where it persists that state.
- **Default**: The “local” backend, storing `terraform.tfstate` in your local directory.
- **Benefits**:
  - **Team Collaboration** (shared remote state and locking).
  - **Security** (sensitive info isn’t stored locally).
  - **Remote Operations** (Terraform can run in remote environments).

### 1.1 Local Backend
1. **Create `main.tf`**:
   ```hcl
   provider "google" {
     project = "YOUR_PROJECT_ID"
     region  = "REGION"
   }

   resource "google_storage_bucket" "test-bucket-for-state" {
     name        = "YOUR_PROJECT_ID"
     location    = "US"
     uniform_bucket_level_access = true
   }

   terraform {
     backend "local" {
       path = "terraform/state/terraform.tfstate"
     }
   }
   ```
2. **Initialize**:
   ```bash
   terraform init
   ```
3. **Apply** (to create the bucket):
   ```bash
   terraform apply
   ```
   Type **yes** when prompted.

4. **Check State**:
   ```bash
   terraform show
   ```
   You’ll see your bucket resource.

### 1.2 Cloud Storage Backend
1. **Replace Local Backend** in `main.tf`:
   ```hcl
   terraform {
     backend "gcs" {
       bucket = "YOUR_BUCKET_NAME"
       prefix = "terraform/state"
     }
   }
   ```
2. **Migrate State**:
   ```bash
   terraform init -migrate-state
   ```
   Type **yes** to confirm migration.  
   Your state file now resides in **Cloud Storage** under `terraform/state/default.tfstate`.

3. **Refresh State**:
   - Make a metadata change (e.g., add a label to your bucket in the Cloud Console).
   - Run:
     ```bash
     terraform refresh
     terraform show
     ```
   - The updated label is in your state.

### 1.3 Clean Up
1. **Revert to Local** (to destroy the GCS bucket):
   ```hcl
   terraform {
     backend "local" {
       path = "terraform/state/terraform.tfstate"
     }
   }
   ```
2. **Re-init**:
   ```bash
   terraform init -migrate-state
   ```
3. **Enable Force Destroy** in your bucket resource:
   ```hcl
   resource "google_storage_bucket" "test-bucket-for-state" {
     name     = "YOUR_PROJECT_ID"
     location = "US"
     uniform_bucket_level_access = true
     force_destroy = true
   }
   ```
4. **Apply** and **Destroy**:
   ```bash
   terraform apply
   # yes
   terraform destroy
   # yes
   ```
   This deletes the bucket and cleans up the resources.

---

## Task 2: Import Existing Resources

### Why Import?
- **Scenario**: Infrastructure was not originally created by Terraform, or it was created manually.
- **Process**:
  1. Identify existing resource(s).
  2. `terraform import` to bring them into state.
  3. Write or update Terraform config to match those resources.
  4. Plan & apply to reconcile config and state.
  5. Terraform now manages those resources.

### 2.1 Example with Docker
1. **Create Container Manually**:
   ```bash
   docker run --name hashicorp-learn --detach --publish 8080:80 nginx:latest
   docker ps
   ```
   Visit the container via Web Preview on port 8080.

2. **Import the Container**
   - **Clone** sample repo:
     ```bash
     git clone https://github.com/hashicorp/learn-terraform-import.git
     cd learn-terraform-import
     ```
   - **Initialize**:
     ```bash
     terraform init
     ```
   - **Add Resource**: In `docker.tf`,
     ```hcl
     resource "docker_container" "web" {}
     ```
   - **Import**:
     ```bash
     terraform import docker_container.web $(docker inspect -f {{.ID}} hashicorp-learn)
     ```
   - **Check State**:
     ```bash
     terraform show
     ```

3. **Create Configuration**
   - If missing required arguments, Terraform shows errors.
   - **Option 1**: Copy from `terraform show -no-color` into `docker.tf`.
   - **Option 2**: Add minimal required attributes (like `image`, `name`, `ports`).

4. **Sync**:
   ```bash
   terraform plan
   terraform apply
   # yes
   ```
   Terraform now fully manages the container.

5. **Add a Docker Image Resource** (optional):
   ```hcl
   resource "docker_image" "nginx" {
     name = "nginx:latest"
   }
   ```
   Reference it in the container:
   ```hcl
   resource "docker_container" "web" {
     image = docker_image.nginx.image_id
     ...
   }
   ```

6. **Update Container**:
   - Change port, for instance:
     ```hcl
     ports {
       external = 8081
       internal = 80
       ...
     }
     ```
   - **Apply**:
     ```bash
     terraform apply
     # yes
     ```
   - Docker container is recreated with new settings.

7. **Destroy**:
   ```bash
   terraform destroy
   # yes
   docker ps
   ```
   Everything is removed.

### Import Limitations
- **Configuration**: `terraform import` doesn’t generate the `.tf` config; you must do it yourself.
- **State**: You only import the current known state from the provider; hidden dependencies or manual changes aren’t automatically known to Terraform.
- **Not All Resources** support import.
- **Terraformer** can help automate some import steps but is not officially endorsed.

---

## Conclusion
You’ve discovered how **Terraform state** works, why it’s critical, and how to use **backends** to manage state effectively—especially in team settings. You also learned how to **import existing resources** into Terraform so you can bring them under infrastructure-as-code management. This helps ensure consistent, versioned, and automated handling of all your cloud infrastructure. 
```