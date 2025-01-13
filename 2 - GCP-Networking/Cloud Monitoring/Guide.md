# Deploy a LAMP Stack on GCE with Monitoring & Logging
Run the following gcloud commands in Cloud Console to set the default region and zone for your lab:

```bash
gcloud config set compute/zone "us-east1-b"
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "us-east1"
export REGION=$(gcloud config get compute/region)
```

## 1. Create a Compute Engine Instance
1. **Console**: Navigation menu → Compute Engine → VM Instances → **Create instance**  
2. **Machine configuration**:
   - **Name**: `lamp-1-vm`
   - **Region**: `<REGION>`
   - **Zone**: `<ZONE>`
   - **Series**: `E2`
   - **Machine type**: `e2-medium`
3. **OS and storage**:
   - **Boot Disk**: Debian GNU/Linux 12 (bookworm)
4. **Networking**:
   - **Firewall**: Check **Allow HTTP traffic**
5. **Create**. Wait for the instance to launch (green check).

---

## 2. Install Apache and PHP
1. On the VM instances page, click **SSH** next to `lamp-1-vm`.
2. Run:
   ```bash
   sudo apt-get update
   sudo apt-get install apache2 php7.0
   # If php7.0 not available, install php5
   sudo service apache2 restart
   ```
3. Back in the VM instances page, click the **External IP** of `lamp-1-vm` to see the Apache default page.

---

## 3. Create a Monitoring Metrics Scope
1. **Console**: Navigation menu → Observability → Monitoring.
2. Wait for **Monitoring Overview** to open. Your Metrics Scope (project) is automatically set up.

---

## 4. Install Monitoring and Logging Agents
1. In the **SSH** terminal of `lamp-1-vm`, run:
   ```bash
   curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
   sudo bash add-google-cloud-ops-agent-repo.sh --also-install
   ```
   - Press **Y** if prompted.
2. Check agent status:
   ```bash
   sudo systemctl status google-cloud-ops-agent"*" 
   ```
   - Press **q** to exit.  
3. Update packages:
   ```bash
   sudo apt-get update
   ```
   The Logging and Monitoring agents are now running on your VM.

---

## 5. Create an Uptime Check
1. **Console**: Monitoring → **Uptime checks** → **Create Uptime Check**.
2. **Protocol**: `HTTP`.
3. **Resource Type**: `Instance`; **Instance**: `lamp-1-vm`.
4. **Check Frequency**: `1 minute`.
5. Continue with defaults:
   - **Title**: `Lamp Uptime Check`.
6. **Test** (should get a green check).
7. **Create**.  
   *It may take a few minutes for the check to become active.*

---

## 6. Create an Alerting Policy
1. **Console**: Monitoring → **Alerting** → **+Create Policy**.
2. **Select a metric**:
   - Uncheck **Active**.
   - Search **Network traffic** → pick **VM instance > Interface > Network traffic**.
3. **Threshold**: Above `500`, **Retest window** = `1 min`.
4. **Notification Channels**:
   - **Manage Notification Channels** → Scroll to **Email** → **Add new**.
   - Enter your email and save.
   - Back to the **Create alerting policy** tab: click **Refresh** under **Notification Channels**, select your email.
5. **Documentation**: Add any message.  
   **Alert name**: `Inbound Traffic Alert`.
6. **Create Policy**.

---

## 7. Create a Dashboard and Charts
1. **Console**: Monitoring → **Dashboards** → **+Create Dashboard**.
   - **Name**: `Cloud Monitoring LAMP Qwik Start Dashboard`.
2. **+ ADD WIDGET** → **Line**:
   - **Widget title**: `CPU Load`
   - Uncheck **Active**, search **CPU load (1m)** → select **VM instance > Cpu > CPU load (1m)**
3. **+ Add WIDGET** → **Line**:
   - **Widget title**: `Received Packets`
   - Uncheck **Active**, search **Received packets** → select **VM instance > Instance > Received packets**

---

## 8. View Logs
1. **Console**: Navigation menu → Logging → **Logs Explorer**.
2. **Resource**: `VM Instance` → `lamp-1-vm`.  
3. **Stream logs** to see real-time logs.

---

## 9. Observe VM Start/Stop in Logs
1. Open **Compute Engine** in a separate window.
2. Stop the `lamp-1-vm` instance (three vertical dots → **Stop**).
   - Watch the logs update in **Logs Explorer**.
3. Start the `lamp-1-vm` instance (three vertical dots → **Start/resume**).
   - Again, watch logs in real time.

---

## 10. Verify Uptime Checks & Alerts
1. **Console**: Monitoring → **Uptime checks** → `Lamp Uptime Check`.
   - After the VM restarts, checks might briefly fail before turning green again.
2. **Alerting**: 
   - Check for any incidents or events.
   - Look for alert emails in your inbox.

> **Tip**: Remove your email notification channel if you don’t want additional alerts after the lab ends.
```