# Managing Cloud Storage Permissions in GCP

This guide demonstrates how to manage Cloud Storage permissions using Google Cloud Console. It covers removing project access for a user and granting specific Cloud Storage permissions.

## Users Involved

- **User 1 (Admin)**
  - Email: `student-03-261c83861e16@qwiklabs.net`
  - Role: Admin

- **User 2 (Storage Object Viewer)**
  - Email: `student-03-fa0d0333b680@qwiklabs.net`
  - Role: Storage Object Viewer

## Project Information

- **Project ID:** `qwiklabs-gcp-02-412fafb20e22`
- **Password:** `YBhwE6iJL24n`

---

## Removing Project Access for User 2

### 1. Switch to User 1's Console

- Ensure you are signed in as **User 1 (Admin)**.
- Navigate to the [Google Cloud Console](https://console.cloud.google.com/).

### 2. Remove Project Viewer Role from User 2

1. **Navigate to IAM:**
   - Click on the **Navigation menu** (☰) in the top-left corner.
   - Select **IAM & Admin** > **IAM**.

2. **Edit User 2's Permissions:**
   - Locate **User 2** (`student-03-fa0d0333b680@qwiklabs.net`) in the member list.
   - Click the **pencil icon** (✏️) next to User 2's entry.
     - *Note: You may need to widen your browser window to see the pencil icon.*

3. **Remove Role:**
   - In the role dropdown, locate the **Project Viewer** role.
   - Click the **trashcan icon** next to the **Project Viewer** role to remove it.

4. **Save Changes:**
   - Click **SAVE** to apply the changes.

   > **Note:** It may take up to **80 seconds** for the changes to propagate.

### 3. Verify Removal of Access

1. **Switch to User 2's Console:**
   - Sign out of User 1's account.
   - Sign in to the [Google Cloud Console](https://console.cloud.google.com/) using **User 2's** credentials.

2. **Attempt to Access Cloud Storage:**
   - Click on the **Navigation menu** (☰).
   - Select **Cloud Storage** > **Buckets**.

3. **Confirm Access Revocation:**
   - You should encounter a **permission error** indicating that you no longer have access.
     - *If you do not see the error immediately, wait for 2 minutes and refresh the console.*

4. **Check Progress:**
   - Return to the lab interface and click **Check my progress** to verify the objective.

---

## Adding Cloud Storage Permissions to User 2

### 1. Copy User 2's Name

- In the **Lab Connection panel**, copy **User 2's** name: `student-03-fa0d0333b680@qwiklabs.net`.

### 2. Switch to User 1's Console

- Ensure you are signed in as **User 1 (Admin)**.
- Navigate to the [Google Cloud Console](https://console.cloud.google.com/).

### 3. Grant Storage Object Viewer Role to User 2

1. **Navigate to IAM:**
   - Click on the **Navigation menu** (☰) in the top-left corner.
   - Select **IAM & Admin** > **IAM**.

2. **Add New Principal:**
   - Click the **+ GRANT ACCESS** button at the top of the IAM page.

3. **Configure Permissions:**
   - **New principals:** Paste **User 2's** email (`student-03-fa0d0333b680@qwiklabs.net`).
   - **Select a role:** Click the dropdown and navigate to **Cloud Storage** > **Storage Object Viewer**.

4. **Save Changes:**
   - Click **SAVE** to grant the permissions.

### 4. Verify Granted Access

1. **Switch to User 2's Console:**
   - Sign out of User 1's account.
   - Sign in to the [Google Cloud Console](https://console.cloud.google.com/) using **User 2's** credentials.

2. **Access Cloud Storage:**
   - Click on the **Navigation menu** (☰).
   - Select **Cloud Storage** > **Buckets**.

3. **Activate Cloud Shell:**
   - Click the **Activate Cloud Shell** icon (🖥️) in the top-right corner of the console.
   - If prompted, click **Continue** to launch Cloud Shell.

4. **List Bucket Contents:**
   - In the Cloud Shell terminal, execute the following command, replacing `[YOUR_BUCKET_NAME]` with your bucket's name:

     ```bash
     gsutil ls gs://qwiklabs-gcp-02-412fafb20e22-152025
     ```

   - **Expected Output:**

     ```
     gs://qwiklabs-gcp-02-412fafb20e22-152025/sample.txt
     ```

   - **Note:** If you encounter an `AccessDeniedException`, wait for a minute and retry the command.

   > **Outcome:** **User 2** now has **Storage Object Viewer** access to the specified Cloud Storage bucket.

---
