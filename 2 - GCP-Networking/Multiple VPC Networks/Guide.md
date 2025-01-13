# Custom VPC Networks and Firewall Rules

## 1. Overview
Create two **custom VPC networks**—`managementnet` and `privatenet`—and configure **firewall rules** to allow SSH, ICMP, and RDP traffic. You’ll also create **VM instances** on these networks, explore their connectivity, and finally set up a VM with **multiple network interfaces**.

---

## 2. Create `managementnet` (Console)
1. **Console Path**: **Navigation menu > VPC network > VPC networks**  
2. Click **Create VPC Network**, then set:
   - **Name**: `managementnet`
   - **Subnet creation mode**: `Custom`
   - **Subnet Name**: `managementsubnet-1`
   - **Region**: `<Region_1>`
   - **IPv4 range**: `10.130.0.0/20`
3. Click **Done**, then **Create**.

---

## 3. Create `privatenet` (gCloud CLI)
In **Cloud Shell**, run:
```bash
gcloud compute networks create privatenet --subnet-mode=custom

gcloud compute networks subnets create privatesubnet-1 \
  --network=privatenet --region=<Region_1> --range=172.16.0.0/24

gcloud compute networks subnets create privatesubnet-2 \
  --network=privatenet --region=<Region_2> --range=172.20.0.0/20
```
List networks:
```bash
gcloud compute networks list
```
List subnets:
```bash
gcloud compute networks subnets list --sort-by=NETWORK
```
**Note**: Custom mode networks only have the subnets you explicitly create.

---

## 4. Create Firewall Rules
### 4.1 For `managementnet` (Console)
1. **Console Path**: **Navigation menu > VPC network > Firewall**  
2. Click **+ Create Firewall Rule**, then set:
   - **Name**: `managementnet-allow-icmp-ssh-rdp`
   - **Network**: `managementnet`
   - **Targets**: `All instances in the network`
   - **Source filter**: `IPv4 Ranges`
   - **Source IPv4 ranges**: `0.0.0.0/0`
   - **Protocols and ports**: 
     - **tcp**: `22,3389`  
     - **Other protocols**: `icmp`
3. Click **Create**.

### 4.2 For `privatenet` (gCloud CLI)
```bash
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp \
  --direction=INGRESS --priority=1000 \
  --network=privatenet --action=ALLOW \
  --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0
```
List firewall rules:
```bash
gcloud compute firewall-rules list --sort-by=NETWORK
```
---

## 5. Create VM Instances
### 5.1 `managementnet-vm-1` (Console)
1. **Console Path**: **Compute Engine > VM instances**
2. Click **Create Instance**, then:
   - **Name**: `managementnet-vm-1`
   - **Region/Zone**: `US_Region` / `US_Zone`
   - **Machine type**: `e2-micro`
   - **Networking**: 
     - **Network**: `managementnet`
     - **Subnetwork**: `managementsubnet-1`
3. Click **Create**.

### 5.2 `privatenet-vm-1` (gCloud CLI)
```bash
gcloud compute instances create privatenet-vm-1 \
  --zone=<Zone> \
  --machine-type=e2-micro \
  --subnet=privatesubnet-1
```
List VMs:
```bash
gcloud compute instances list --sort-by=ZONE
```
---

## 6. Explore Connectivity
1. **External IP**:
   - You can ping external IPs of all VMs (ICMP is allowed by firewall).
2. **Internal IP**:
   - You can only ping internal IPs of VMs on the **same VPC** (`mynet-vm-1` ↔ `mynet-vm-2`).
   - **Different VPCs** (`managementnet-vm-1`, `privatenet-vm-1`) cannot reach each other’s internal IPs unless peered or connected via VPN.

---

## 7. Create a VM with Multiple Network Interfaces
### 7.1 `vm-appliance` with three NICs
1. **Console Path**: **Compute Engine > VM instances**  
2. Click **Create Instance**, set:
   - **Name**: `vm-appliance`
   - **Machine type**: `e2-standard-4` (allows multiple NICs)
3. Click **Networking**:
   - **nic0**: `privatenet` / `privatesubnet-1`
   - **Add network interface**:
     - **nic1**: `managementnet` / `managementsubnet-1`
     - **nic2**: `mynetwork` / `mynetwork`
4. Click **Create**.

### 7.2 Interface Verification
- **Cloud Console**: Check each NIC’s subnet (e.g., `172.16.x.x`, `10.130.x.x`, `10.128.x.x`).
- **SSH into vm-appliance**:  
  ```bash
  sudo ifconfig
  ```
  You’ll see `eth0`, `eth1`, and `eth2` each with a different internal IP.

### 7.3 Testing Connectivity
- **Ping each VM** on the same VPC subnets to confirm:
  - `privatenet-vm-1` (via `eth0`)
  - `managementnet-vm-1` (via `eth1`)
  - `mynet-vm-1` (via `eth2`)
- **Note**: Traffic to a subnet not directly attached to one of the interfaces defaults to `eth0`.

---

## 8. Summary
- **Custom networks** give fine-grained control over subnet creation.
- **Firewall rules** manage ingress for specific protocols.
- **Multiple interfaces** let VMs connect to multiple networks simultaneously.
- **Routing** matters—traffic to unknown subnets leaves via the **default route**.

Use these practices to design flexible, secure network topologies in Google Cloud. 
```