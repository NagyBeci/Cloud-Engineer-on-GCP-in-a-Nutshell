# Container Orchestration with Kubernetes

## 1. Set Up the Environment

### Set Your Zone
```bash
gcloud config set compute/zone us-east4-a
```

### Get the Sample Code
```bash
gsutil -m cp -r gs://spls/gsp053/orchestrate-with-kubernetes .
cd orchestrate-with-kubernetes/kubernetes
```

### Create a GKE Cluster (3 Nodes)
```bash
gcloud container clusters create bootcamp \
  --machine-type e2-small \
  --num-nodes 3 \
  --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"
```
---

## 2. Learn About the Deployment Object

Use `kubectl explain` to understand Kubernetes objects and fields:

```bash
kubectl explain deployment
kubectl explain deployment --recursive
kubectl explain deployment.metadata.name
```
---

## 3. Create Deployments and Services

### Create the `auth` Deployment
1. Update `deployments/auth.yaml`:
   ```yaml
   containers:
   - name: auth
     image: "kelseyhightower/auth:1.0.0"
   ```
2. Save changes, then run:
   ```bash
   kubectl create -f deployments/auth.yaml
   kubectl get deployments
   kubectl get replicasets
   kubectl get pods
   ```
3. Create the `auth` service:
   ```bash
   kubectl create -f services/auth.yaml
   ```

### Create and Expose the `hello` Deployment
```bash
kubectl create -f deployments/hello.yaml
kubectl create -f services/hello.yaml
```

### Create and Expose the `frontend` Deployment
```bash
kubectl create secret generic tls-certs --from-file tls/
kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
kubectl create -f deployments/frontend.yaml
kubectl create -f services/frontend.yaml
```
**Tip**: Use `kubectl get services frontend` to see the external IP.  
```bash
curl -ks https://<EXTERNAL-IP>
# OR
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`
```
You should see the "hello" response.

---

## 4. Scaling a Deployment

### Scale Up
```bash
kubectl scale deployment hello --replicas=5
kubectl get pods | grep hello- | wc -l  # should show 5
```

### Scale Down
```bash
kubectl scale deployment hello --replicas=3
kubectl get pods | grep hello- | wc -l  # should show 3
```

---

## 5. Rolling Updates

### Trigger a Rolling Update
```bash
kubectl edit deployment hello
# Change image to kelseyhightower/hello:2.0.0
```
Kubernetes creates a new ReplicaSet and performs a rolling update.

```bash
kubectl get replicaset
kubectl rollout history deployment/hello
```

### Pause the Rolling Update
```bash
kubectl rollout pause deployment/hello
kubectl rollout status deployment/hello
```
Check Pod images:
```bash
kubectl get pods -o jsonpath --template='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[0].image}{"\n"}{end}'
```

### Resume the Rolling Update
```bash
kubectl rollout resume deployment/hello
kubectl rollout status deployment/hello
# "successfully rolled out"
```

### Roll Back
```bash
kubectl rollout undo deployment/hello
kubectl rollout history deployment/hello
kubectl get pods -o jsonpath --template='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[0].image}{"\n"}{end}'
```
Now all pods are back to the previous version.

---

## 6. Canary Deployments

### Create a Canary Deployment
```bash
kubectl create -f deployments/hello-canary.yaml
kubectl get deployments
```
Both `hello` and `hello-canary` respond through the same `hello` service. Because `hello-canary` has fewer pods, fewer users hit the canary.

Check versions:
```bash
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
```
Requests alternate between **1.0.0** and **2.0.0** versions.

**Session Affinity**:  
Set `sessionAffinity: ClientIP` in your service spec to keep users on the same version for each request.

---

## 7. Blue-Green Deployments

### Service Configuration
Use a service with a **version** selector:
```bash
kubectl apply -f services/hello-blue.yaml
```
This service points to **app: hello, version: 1.0.0** (“blue”).

### Deploy the "Green" Version
```bash
kubectl create -f deployments/hello-green.yaml
```
Validate you still get **1.0.0** from the service:
```bash
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
```

### Switch to "Green"
```bash
kubectl apply -f services/hello-green.yaml
```
Now you always get **2.0.0**:
```bash
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
```

### Roll Back to "Blue"
```bash
kubectl apply -f services/hello-blue.yaml
```
Check version again to ensure it’s back to **1.0.0**.

---

## Summary
- **Deployments** allow you to run, manage, and scale pods.
- **Rolling updates** let you update images without downtime.
- **Canary deployments** let you test new versions on a subset of users.
- **Blue-green deployments** switch traffic between two fully deployed versions.

You now have hands-on experience with multiple Kubernetes deployment strategies!
```