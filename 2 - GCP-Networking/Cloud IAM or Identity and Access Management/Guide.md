# Managing IAM Permissions and Cloud Storage Access

## Task 1: Explore IAM Console and Project-Level Roles

1. **IAM Console**  
   - Go to **Navigation menu > IAM & Admin > IAM**.
   - Click **+GRANT ACCESS** and review the three **Basic** (primitive) roles:
     - **Viewer**: Read-only (view existing resources and data).
     - **Editor**: Viewer permissions + modify existing resources.
     - **Owner**: Editor permissions + manage roles, permissions, and billing.

2. **Check Your Role**  
   - If you see you can set IAM roles, you likely have **Project owner**.

3. **Verify Editor Role**  
   - Switch to the **Username 2** console.  
   - Notice they have **Viewer** role.  
   - **+GRANT ACCESS** is grayed out, showing that Viewer permissions don’t allow setting IAM policies.

---

## Task 2: Prepare a Cloud Storage Bucket for Access Testing

1. **Create a Bucket** (as **Username 1**):
   - **Navigation menu > Cloud Storage > Buckets**  
   - Click **+CREATE** and use a **globally unique name**.  
   - **Location Type**: Multi-Region  
   - Click **CREATE**, confirm if prompted.

2. **Upload a Sample File**
   - On the Bucket details page, click **UPLOAD FILES**.  
   - Rename the uploaded file to `sample.txt`.

3. **Verify Project Viewer Access** (as **Username 2**):
   - Go to **Cloud Storage > Buckets**.
   - You can see the bucket and file but cannot modify or delete them (Viewer permissions).

---

## Task 3: Remove Project Access

1. **Remove Viewer Role** (as **Username 1**):
   - **Navigation menu > IAM & Admin > IAM**.
   - Click the **pencil** icon next to **Username 2**.
   - Click the **trashcan** icon beside **Project Viewer**, then **SAVE**.
   - It may take up to 80 seconds for changes to propagate.

2. **Verify Removal** (as **Username 2**):
   - Go to **Cloud Storage > Buckets**.  
   - You should now see a **permission error** (or get signed out).

---

## Task 4: Add Cloud Storage Permissions

1. **Grant Storage Object Viewer** (as **Username 1**):
   - **Navigation menu > IAM & Admin > IAM**.  
   - Click **+GRANT ACCESS**; add **Username 2** as **New principals**.  
   - Select **Cloud Storage > Storage Object Viewer**.  
   - Click **SAVE**.

2. **Verify Access** (as **Username 2**):
   - **Console** might not show buckets because there’s no project-level Viewer role.
   - Use **Cloud Shell**:
     ```bash
     gsutil ls gs://[YOUR_BUCKET_NAME]
     ```
   - You should see `sample.txt`, indicating object-level read access.

You have now tested granting and revoking project-level roles and assigning a more specific role (Storage Object Viewer) to a single service. 
```