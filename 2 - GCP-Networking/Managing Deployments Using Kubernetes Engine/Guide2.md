# Deploy a Kubernetes Cluster on GCP with Monitoring & Logging

Follow these steps to create a Kubernetes (GKE) cluster on Google Cloud Platform, deploy a sample workload, scale the cluster, and set up basic monitoring and logging.

---

## 1. Set the Default Region and Zone
Open your [Cloud Console](https://console.cloud.google.com/) and run the following **gcloud** commands to set your default region and zone:

```bash
gcloud config set compute/zone "us-east1-b"
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "us-east1"
export REGION=$(gcloud config get compute/region)
```

---

## 2. Create a GKE Cluster (3 Nodes)
1. In the Cloud Console, go to the **Navigation menu** → **Kubernetes Engine** → **Clusters**.
2. Click **Create** (or **Create cluster**).
3. **Cluster basics**:
   - **Name**: `my-first-gke-cluster`
   - **Location type**: **Zonal**  
   - **Zone**: `<ZONE>` (e.g., `us-east1-b`)
4. **Cluster version**: Leave the default or select the most recent stable version.
5. **Node pool**:
   - **Number of nodes**: `3`
   - **Machine type**: `e2-medium` (sufficient for this demo)
6. **Networking**:
   - Keep defaults for now, or enable **HTTP Load Balancing** if you’d like GCP-managed L7 load balancing.
7. Click **Create**.  
   *It may take a few minutes for the cluster to be fully provisioned.*

Alternatively, you can create the cluster via the command line:
```bash
gcloud container clusters create "my-first-gke-cluster" \
  --zone "$ZONE" \
  --machine-type "e2-medium" \
  --num-nodes "3"
```
  
---

## 3. Configure kubectl
Once the cluster is created, configure your local **kubectl** to talk to your new cluster:
```bash
gcloud container clusters get-credentials "my-first-gke-cluster" --zone "$ZONE"
```

You can verify connection by running:
```bash
kubectl get nodes
```
You should see three nodes in the **Ready** state.

---

## 4. Deploy a Sample Application
1. Let’s deploy a simple Nginx Deployment with a Service to expose it:

   ```bash
   kubectl create deployment nginx-deployment --image=nginx
   ```
2. Expose the deployment as a service of type **LoadBalancer** (this will provision an external IP on GCP):
   ```bash
   kubectl expose deployment nginx-deployment --port=80 --target-port=80 --type=LoadBalancer
   ```
3. Check the service status:
   ```bash
   kubectl get services
   ```
   Look for the **EXTERNAL-IP** field in the `nginx-deployment` service. When an IP is assigned (may take a minute or two), open it in your browser to see the default Nginx page.

---

## 5. Scale the Cluster to 5 Nodes
If you need more resources, scale the **node pool** to 5 nodes. You can do this in two ways:

### Option A: Console
1. **Navigation menu** → **Kubernetes Engine** → **Clusters** → click on `my-first-gke-cluster`.
2. Scroll to **Node pools**, click **Actions** → **Edit node pool**.
3. Change **Number of nodes** to `5`.
4. Click **Save**.

### Option B: CLI
```bash
gcloud container clusters resize "my-first-gke-cluster" \
  --zone "$ZONE" \
  --node-pool "default-pool" \
  --num-nodes "5"
```
> It may take a few minutes for additional nodes to be added.  
Check the update:
```bash
kubectl get nodes
```
You should now see 5 nodes.

---

## 6. Enable Cloud Monitoring & Logging
Google Kubernetes Engine integrates with **Cloud Operations** (formerly Stackdriver). Most clusters now come with Cloud Monitoring and Logging enabled by default. 

### Verify or Enable Monitoring and Logging
1. **Navigation menu** → **Kubernetes Engine** → **Clusters** → select your cluster.
2. Under **Features**, ensure **Cloud Logging** and **Cloud Monitoring** are enabled.

### Install Ops Agents (optional)
If you are running GCE instances or want extra metrics on GKE nodes, you can install the Google Ops Agent. However, for GKE autopilot or standard clusters with built-in features, this is typically pre-configured.

---

## 7. View Logs in Cloud Logging
1. **Console** → **Navigation menu** → **Logging** → **Logs Explorer**.
2. In **Resource**, select **GKE Cluster** or **Kubernetes Container**.
3. You can filter by **Namespace**, **Pod**, or **Container** to see specific logs from your workloads.

---

## 8. View Metrics & Create Dashboards
1. **Console** → **Navigation menu** → **Monitoring** → **Dashboards**.
2. Click **+Create Dashboard** → give it a name, e.g., `GKE Demo Dashboard`.
3. **+Add Widget** → pick **Line** or **Time series** chart.
   - Choose **GKE Container** or **GCE VM Instance** metrics (e.g., CPU usage, memory usage, etc.).
   - Save your widget.

---

## 9. Set Up Uptime Checks
1. **Monitoring** → **Uptime checks** → **+Create Uptime Check**.
2. **Protocol**: `HTTP`.
3. **Resource Type**: `URL`.  
   - **Host name**: Use the **EXTERNAL-IP** of your `nginx-deployment` service (or the domain you mapped to it).
4. **Check Frequency**: `1 minute`.
5. **Title**: `Nginx Uptime Check`.
6. Click **Test** and then **Create**.  
   *It may take a few minutes for the check to start reporting status.*

---

## 10. Create an Alerting Policy
1. **Monitoring** → **Alerting** → **+Create Policy**.
2. **Select a metric**:
   - Uncheck **Active**.
   - For example, search **CPU usage** → pick **Kubernetes Container > CPU usage** (or any metric you want to monitor).
3. **Threshold**: Above a certain value (e.g., 80%), for a specific time window.
4. **Notification Channels**:
   - Configure email, SMS, or PagerDuty as needed.
5. **Documentation**: Optionally add runbooks or instructions.
6. **Alert name**: e.g., `High CPU on GKE`.
7. **Create Policy**.

---

## 11. Clean Up
After you are done exploring:
1. Delete or scale down your GKE cluster to avoid incurring charges:
   ```bash
   gcloud container clusters delete "my-first-gke-cluster" --zone "$ZONE"
   ```
2. Or, delete just the node pool if you want to keep the cluster environment.

> **Tip**: Monitor your usage costs in [Billing](https://console.cloud.google.com/billing).

---

## Summary
You have successfully:
1. Created a GKE cluster with 3 nodes (scaled to 5).
2. Deployed a sample Nginx application.
3. Exposed it with a load balancer.
4. Configured basic monitoring, logging, and an uptime check.
5. Created an alerting policy.

Congratulations! You now have a basic understanding of running Kubernetes on GCP. This skill set is crucial for Cloud Engineers managing containerized applications at scale.
```