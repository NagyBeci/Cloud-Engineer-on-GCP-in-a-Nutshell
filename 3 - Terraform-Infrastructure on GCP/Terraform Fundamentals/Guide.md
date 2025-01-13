# Basics of Terraform on Google Cloud

## Task 1: Verify Terraform Installation
1. **Cloud Shell**: Open a new Cloud Shell session.
2. **Check Terraform**:
   ```
   terraform
   ```
   You should see the Terraform help and version info, confirming it’s installed.

---

## Task 2: Build Infrastructure

### 2.1 Create a Terraform Configuration
1. **Create a file**:
   ```
   touch instance.tf
   ```
2. **Open Editor** (click **Open Editor** in Cloud Shell), then **add** this content to `instance.tf`:
   ```hcl
   resource "google_compute_instance" "terraform" {
     project      = "qwiklabs-gcp-02-5cecb135c593"
     name         = "terraform"
     machine_type = "e2-medium"
     zone         = "europe-west1-c"

     boot_disk {
       initialize_params {
         image = "debian-cloud/debian-11"
       }
     }

     network_interface {
       network = "default"
       access_config {}
     }
   }
   ```

3. **Verify**:
   ```
   ls
   ```
   Ensure you only see `instance.tf` (and no other `.tf` files).

### 2.2 Initialize Terraform
Run:
```
terraform init
```
- **Purpose**: Installs providers (in this case, Google provider) needed to manage resources in your config.

### 2.3 Preview the Execution Plan
```
terraform plan
```
- **Purpose**: Shows you the resources Terraform plans to create.

### 2.4 Apply the Changes
```
terraform apply
```
- **Purpose**: Provisions the resources.  
- **Type** `yes` at the prompt to confirm.  

Terraform will spin up the VM instance defined in `instance.tf`. Once complete, you have a running Compute Engine instance managed by Terraform!
```