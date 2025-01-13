# GCP Effective Usage Guide

## 1. **Set Default Region and Zone**

- Open the [Google Cloud Console](https://console.cloud.google.com/).
- Open the **Cloud Shell**.
- Run the following `gcloud` commands to set your default region and zone:

  ```bash
  gcloud config set compute/zone "us-central1-b"
  export ZONE=$(gcloud config get compute/zone)

  gcloud config set compute/region "us-central1"
  export REGION=$(gcloud config get compute/region)


## 2. **Create a Compute Engine Instance**

1. **Navigate to VM Instances**
   
   - In the **Navigation menu** (☰), select **Compute Engine > VM Instances**.
   - Click on the **"Create Instance"** button.

2. **Configure the Instance**
   
   - **Name:** `lamp-1-vm`
   - **Region:** `us-central1`
   - **Zone:** `us-central1-b`
   - **Machine Series:** `E2`
   - **Machine Type:** `e2-medium`

3. **Set Boot Disk**
   
   - Click on **"OS and storage"**.
   - **Boot Disk:** Select **Debian GNU/Linux 12 (bookworm)**.

4. **Configure Networking**
   
   - Click on **"Networking"**.
   - **Firewall:** Check **"Allow HTTP traffic"**.

5. **Create the Instance**
   
   - Scroll down and click **"Create"**.
   - Wait until the instance status shows a green checkmark.

## 3. **Install Apache2 HTTP Server**

1. **Access the VM**
   
   - In the **VM Instances** list, click **"SSH"** next to `lamp-1-vm` to open a terminal.

2. **Run Installation Commands**
   
   ```bash
   sudo apt-get update
   sudo apt-get install apache2 php7.0 -y
   sudo service apache2 restart
   ```
   
   - *If `php7.0` is unavailable, use `php5` instead.*

## 4. **Create a Monitoring Metrics Scope**

1. **Navigate to Monitoring**
   
   - In the **Cloud Console**, click on the **Navigation menu** (☰).
   - Select **View All Products > Observability > Monitoring**.

2. **Initialize Metrics Scope**
   
   - On the **Monitoring Overview** page, your metrics scope project is automatically ready.

## 5. **Install Monitoring and Logging Agents**

1. **Install Cloud Monitoring Agent**
   
   - In the **SSH** terminal of your VM instance, run:
   
     ```bash
     curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
     sudo bash add-google-cloud-ops-agent-repo.sh --also-install
     ```
   
   - Press `Y` if prompted to continue.

2. **Verify Agent Installation**
   
   ```bash
   sudo systemctl status google-cloud-ops-agent
   ```
   
   - Press `q` to exit the status view.

3. **Update Package Lists**
   
   ```bash
   sudo apt-get update
   ```
   
   - *It is recommended to run the Cloud Logging agent on all VM instances to stream logs to Cloud Logging.*

## 6. **Create an Uptime Check**

1. **Navigate to Uptime Checks**
   
   - In the **Cloud Console**, go to the **Navigation menu** (☰).
   - Click on **Uptime checks**.

2. **Create the Uptime Check**
   
   - Click **"Create Uptime Check"**.
   - **Protocol:** Select **HTTP**.
   - **Resource Type:** Select **Instance**.
   - **Instance:** Choose `lamp-1-vm`.
   - **Check Frequency:** Select **1 minute**.
   - Click **"Continue"**.

3. **Configure Response Validation**
   
   - Accept the default settings.
   - Click **"Continue"**.

4. **Set Alert & Notification**
   
   - Accept the default settings.
   - Click **"Continue"**.

5. **Finalize the Uptime Check**
   
   - **Title:** Enter `Lamp Uptime Check`.
   - Click **"Test"** to verify the connection.
   - Once verified with a green checkmark, click **"Create"**.
   
   - *Note: The uptime check may take a few minutes to become active.*

## 7. **Create an Alerting Policy**

1. **Navigate to Alerting**
   
   - In the **Cloud Console**, go to the **Navigation menu** (☰).
   - Click on **Alerting**.

2. **Create the Alerting Policy**
   
   - Click **"+ Create Policy"**.

3. **Select a Metric**
   
   - Click on **"Select a metric"** dropdown.
   - Uncheck **"Active"**.
   - In the filter, type **"Network traffic"**.
   - Select **VM instance > Interface > Network traffic (agent.googleapis.com/interface/traffic)**.
   - Click **"Apply"**.

4. **Configure the Condition**
   
   - **Threshold Position:** Select **Above threshold**.
   - **Threshold Value:** Enter `500`.
   - **Advanced Options > Retest Window:** Set to **1 min**.
   - Click **"Next"**.

5. **Set Up Notification Channels**
   
   - Click on the dropdown next to **Notification Channels**.
   - Select **"Manage Notification Channels"**.
   
   - **Add Email Channel:**
     - Scroll down and click **"ADD NEW"** under **Email**.
     - **Email Address:** Enter your personal email.
     - **Display Name:** Provide a name for the channel.
     - Click **"Save"**.

   - Return to the **Create Alerting Policy** tab.
   - Click on **"Notification Channels"** again.
   - Click the **Refresh** icon to load the newly added channel.
   - Select your **Display Name** and click **"OK"**.

6. **Add Documentation**
   
   - Add a message in the documentation section.
   - **Alert Name:** Enter `Inbound Traffic Alert`.

7. **Finalize the Policy**
   
   - Click **"Next"**.
   - Review the alert settings.
   - Click **"Create Policy"**.
   
   - *Your alert has been created. Proceed to create a dashboard and chart, then check Cloud Logging.*

## 8. **Create a Dashboard and Chart**

1. **Navigate to Dashboards**
   
   - In the **Cloud Console**, go to the **Navigation menu** (☰).
   - Click on **Dashboards**.

2. **Create a New Dashboard**
   
   - Click **"+ Create Dashboard"**.
   - **Name:** Enter `Cloud Monitoring LAMP Qwik Start Dashboard`.

3. **Add the First Chart (CPU Load)**
   
   - Click **"+ ADD WIDGET"**.
   - Select **Line** under **Visualization**.
   - **Widget Title:** Enter `CPU Load`.
   
   - **Select Metric:**
     - Click on **"Select a metric"** dropdown.
     - Uncheck **"Active"**.
     - Type **"CPU load (1m)"** in the filter.
     - Select **VM instance > CPU**.
     - Choose **CPU load (1m)**.
     - Click **"Apply"**.
   
   - Click **"Save"** to view the graph.

4. **Add the Second Chart (Received Packets)**
   
   - Click **"+ ADD WIDGET"**.
   - Select **Line** under **Visualization**.
   - **Widget Title:** Enter `Received Packets`.
   
   - **Select Metric:**
     - Click on **"Select a metric"** dropdown.
     - Uncheck **"Active"**.
     - Type **"Received packets"** in the filter.
     - Select **VM instance > Instance**.
     - Choose **Received packets**.
     - Click **"Apply"**.
   
   - Click **"Save"** to view the chart data.

## 9. **View Your Logs**

1. **Navigate to Logs Explorer**
   
   - In the **Cloud Console**, go to the **Navigation menu** (☰).
   - Click on **Logging > Logs Explorer**.

2. **Filter Logs for Your VM**
   
   - Click on **"Resource"** dropdown.
   - Select **VM Instance > lamp-1-vm**.
   - Click **"Apply"**.
   
   - Leave other fields at their default values.
   - Click **"Stream logs"** to view real-time logs for your VM instance.

3. **Monitor VM Instance Changes**
   
   - **Open Compute Engine in a New Window:**
     - Navigate to **Compute Engine** in a separate browser window.
     - Select **Navigation menu > Compute Engine**.
   
   - **Arrange Windows Side by Side:**
     - Position the **Logs Explorer** and **Compute Engine** windows next to each other for easy monitoring.
   
   - **Stop the VM Instance:**
     - In the **Compute Engine** window, locate `lamp-1-vm`.
     - Click the three vertical dots (⋮) on the right and select **Stop**.
     - Confirm to stop the instance.
     - Wait a few minutes for the instance to stop.
   
   - **Verify in Logs Explorer:**
     - Observe the logs for the VM stopping event in the **Logs Explorer**.
   
   - **Start the VM Instance:**
     - In the **Compute Engine** window, click the three vertical dots (⋮) next to `lamp-1-vm`.
     - Select **Start/Resume** and confirm.
     - Wait a few minutes for the instance to restart.
   
   - **Verify in Logs Explorer:**
     - Monitor the logs for the VM starting event in the **Logs Explorer**.
```