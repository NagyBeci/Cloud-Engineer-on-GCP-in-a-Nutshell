# Terraform Essentials on Google Cloud

## Task 1: Build Infrastructure

### 1.1 Create the `main.tf` File
1. In **Cloud Shell**, create a file:
   ```bash
   touch main.tf
   ```
2. Click **Open Editor** and add the following content to `main.tf`:
   ```hcl
   terraform {
     required_providers {
       google = {
         source  = "hashicorp/google"
         version = "3.5.0"
       }
     }
   }

   provider "google" {
     project = "qwiklabs-gcp-01-e22d45259e56"
     region  = "europe-west1"
     zone    = "europe-west1-d"
   }

   resource "google_compute_network" "vpc_network" {
     name = "terraform-network"
   }
   ```
   > **Note**: For Terraform 0.12, remove the `terraform {}` block.

### 1.2 Initialize Terraform
```bash
terraform init
```
- Installs the **Google provider** plugin.

### 1.3 Apply the Configuration
```bash
terraform apply
```
- Review the plan and type `yes` to confirm.
- Terraform creates the `terraform-network`.

### 1.4 Verify the Network
- **Console**: Navigation Menu → VPC Network → **terraform-network** should be listed.
- **Cloud Shell**:
  ```bash
  terraform show
  ```
  Shows the current state of your infrastructure.

---

## Task 2: Change Infrastructure

### 2.1 Add a Compute Instance
Add this resource to `main.tf` (below the existing code):
```hcl
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }
}
```
Then:
```bash
terraform apply
```
- Type `yes` to create the instance.

### 2.2 Modify the Instance (In-Place Update)
Add tags:
```hcl
tags = ["web", "dev"]
```
Run:
```bash
terraform apply
```
- Terraform updates the instance in place (`~` prefix).

### 2.3 Destructive Changes
Change the boot disk image to:
```hcl
boot_disk {
  initialize_params {
    image = "cos-cloud/cos-stable"
  }
}
```
Then:
```bash
terraform apply
```
- Terraform must **destroy** and **recreate** the VM (`-/+` prefix).

### 2.4 Destroy Infrastructure
When ready to remove all:
```bash
terraform destroy
```
- Type `yes`. Terraform will tear down the instance first, then the network.

---

## Task 3: Create Resource Dependencies

1. **Re-create** network and instance:
   ```bash
   terraform apply
   ```
2. **Add a Static IP**:
   ```hcl
   resource "google_compute_address" "vm_static_ip" {
     name = "terraform-static-ip"
   }
   ```
3. **Update the VM’s network interface** to reference the static IP:
   ```hcl
   network_interface {
     network = google_compute_network.vpc_network.self_link
     access_config {
       nat_ip = google_compute_address.vm_static_ip.address
     }
   }
   ```
4. **Plan and Apply**:
   ```bash
   terraform plan -out static_ip
   terraform apply "static_ip"
   ```
   - Terraform infers that the IP must be created before assigning it to the VM.

### 3.1 Implicit and Explicit Dependencies
- **Implicit**: Using references like `google_compute_address.vm_static_ip.address`.
- **Explicit**: When dependencies aren't visible, use `depends_on`.

**Example**:
```hcl
resource "google_storage_bucket" "example_bucket" {
  name     = "<UNIQUE-BUCKET-NAME>"
  location = "US"
}

resource "google_compute_instance" "another_instance" {
  depends_on = [google_storage_bucket.example_bucket]
  # ...
}
```
- Run:
  ```bash
  terraform plan
  terraform apply
  ```
- The bucket is created before the instance that depends on it.

---

## Task 4: Provision Infrastructure

### 4.1 Local Exec Provisioner
Modify the **first** `vm_instance` resource:
```hcl
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"
  tags         = ["web", "dev"]

  provisioner "local-exec" {
    command = "echo ${google_compute_instance.vm_instance.name}: ${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip} >> ip_address.txt"
  }

  # existing config...
}
```
- **local-exec** runs **locally** on the machine running Terraform (not on the VM).

After saving, taint the VM to force recreation:
```bash
terraform taint google_compute_instance.vm_instance
terraform apply
```
- The VM is recreated, and `ip_address.txt` now appears on your local machine with the VM’s name and external IP.

### 4.2 Tainted Resources
- If a provisioner fails, Terraform marks the resource as **tainted**.
- The next apply destroys and re-creates that resource.

### 4.3 Destroy Provisioners (Optional)
- You can also define provisioners that run on resource **destroy**.

---

## Summary
- **Terraform** manages your Google Cloud infrastructure using declarative configs.
- **init, plan, apply, destroy** are the core commands.
- **In-place** vs. **destructive** changes show how Terraform updates resources.
- **Dependencies** (implicit or explicit) ensure resources are created in the correct order.
- **Provisioners** handle extra tasks like running scripts or capturing info after creation.