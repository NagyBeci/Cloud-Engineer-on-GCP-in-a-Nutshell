# GCP Effective Usage Guide

## 1. **Create a Cloud Run Function**

### 1.1 Navigate to Cloud Run Functions
- Open the [Google Cloud Console](https://console.cloud.google.com/).
- Click the **Navigation menu** (☰) and select **VIEW ALL PRODUCTS**.
- Under **Serverless**, choose **Cloud Run functions**.

### 1.2 Create a New Function
- Click **"Create function"**.
- Fill in the **Create function** dialog:

  | **Field**            | **Value**                                       |
  |----------------------|-------------------------------------------------|
  | **Environment**      | Cloud Run function                              |
  | **Function name**    | `GCFunction`                                    |
  | **Region**           | `us-east4`                                      |
  | **Trigger type**     | HTTPS                                           |
  | **Authentication**   | **Allow unauthenticated invocations**           |
  | **Memory allocated** | Default settings                                |
  | **Autoscaling**      | Maximum instances: `5`                          |

- Click **"Next"**.
- If prompted, click **"ENABLE"** to activate required APIs.

## 2. **Deploy the Function**

### 2.1 Use Default Source Code
- In **Source code**, select **Inline editor**.
- Use the default `helloHttp` function in `index.js`.

### 2.2 Deploy
- Scroll down and click **"Deploy"**.
- A spinner icon appears; wait for it to turn into a green checkmark indicating successful deployment.

## 3. **Test the Function**

### 3.1 Access Testing
- On the function's dashboard, click **"TESTING"**.

### 3.2 Trigger the Function
- In **Triggering event**, enter:
  ```json
  {"message": "Hello World!"}
  ```
- Click **"Test the function"**.

### 3.3 Verify Output
- **Output** should display **Hello World!**.
- **Logs** should show a status code of `200` (may take a minute).

## 4. **Create a Custom Function: helloWorld**

### 4.1 Set Default Region in Cloud Shell
- Open **Cloud Shell**.
- Run:
  ```bash
  gcloud config set run/region us-east4
  ```

### 4.2 Create Function Directory
- Run:
  ```bash
  mkdir gcf_hello_world && cd gcf_hello_world
  ```

### 4.3 Create `index.js`
- Open `index.js`:
  ```bash
  nano index.js
  ```
- Paste the following code:
  ```javascript
  const functions = require('@google-cloud/functions-framework');

  // CloudEvent callback for Pub/Sub trigger
  functions.cloudEvent('helloPubSub', cloudEvent => {
    const base64name = cloudEvent.data.message.data;
    const name = base64name
      ? Buffer.from(base64name, 'base64').toString()
      : 'World';
    console.log(`Hello, ${name}!`);
  });
  ```
- Save and exit (`Ctrl + X`, then `Y`).

### 4.4 Create `package.json`
- Open `package.json`:
  ```bash
  nano package.json
  ```
- Paste the following content:
  ```json
  {
    "name": "gcf_hello_world",
    "version": "1.0.0",
    "main": "index.js",
    "scripts": {
      "start": "node index.js",
      "test": "echo \"Error: no test specified\" && exit 1"
    },
    "dependencies": {
      "@google-cloud/functions-framework": "^3.0.0"
    }
  }
  ```
- Save and exit (`Ctrl + X`, then `Y`).

### 4.5 Install Dependencies
- Run:
  ```bash
  npm install
  ```
- **Expected Output:**
  ```
  added 140 packages, and audited 141 packages in 9s

  27 packages are looking for funding
  run `npm fund` for details

  found 0 vulnerabilities
  ```

## 5. **Deploy Your Custom Function**

### 5.1 Deploy to Pub/Sub Topic
- Run the deployment command (replace `YOUR_PROJECT_ID` accordingly):
  ```bash
  gcloud functions deploy nodejs-pubsub-function \
    --gen2 \
    --runtime=nodejs20 \
    --region=us-east4 \
    --source=. \
    --entry-point=helloPubSub \
    --trigger-topic cf-demo \
    --stage-bucket YOUR_PROJECT_ID-bucket \
    --service-account cloudfunctionsa@YOUR_PROJECT_ID.iam.gserviceaccount.com \
    --allow-unauthenticated
  ```
- If prompted about `serviceAccountTokenCreator`, select **"n"**.

### 5.2 Verify Deployment
- Run:
  ```bash
  gcloud functions describe nodejs-pubsub-function --region=us-east4
  ```
- **Check for `State: ACTIVE`** in the output.

## 6. **Test the Custom Function**

### 6.1 Publish a Message to Pub/Sub
- Run:
  ```bash
  gcloud pubsub topics publish cf-demo --message="Cloud Function Gen2"
  ```
- **Example Output:**
  ```
  messageIds:
  - '11927162971409664'
  ```

### 6.2 Verify Logs
- Run:
  ```bash
  gcloud functions logs read nodejs-pubsub-function --region=us-east4
  ```
- *Alternatively, go to **Logging > Logs Explorer** in the Cloud Console.*

## 7. **View Logs**

### 7.1 Access Logs Explorer
- Open the [Google Cloud Console](https://console.cloud.google.com/).
- Click the **Navigation menu** (☰) and select **Logging > Logs Explorer**.

### 7.2 Filter Logs
- Set filters:
  - **Resource:** Cloud Function
  - **Function Name:** `nodejs-pubsub-function`
- Click **"Run Query"**.

### 7.3 Review Log Entries
- Look for entries like:
  ```
  LOG: Hello, Cloud Function Gen2!
  LOG: Hello, Friend!
  ```
- *Note: Logs may take up to 10 minutes to appear.*

### 7.4 Confirm Execution
- Each published message should generate a corresponding log entry.
  - *Example:* Publishing `"Cloud Function Gen2"` results in `Hello, Cloud Function Gen2!`.

---

*Your Cloud Run function is now deployed, tested, and logging successfully.*
```