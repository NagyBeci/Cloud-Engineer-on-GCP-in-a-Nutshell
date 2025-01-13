# GCP Effective Usage Guide

## 1. **Create a Cloud Run Function**

1. **Navigate to Cloud Run Functions**
   
   - Open the [Google Cloud Console](https://console.cloud.google.com/).
   - In the **Navigation menu** (☰), click **VIEW ALL PRODUCTS**.
   - Under the **Serverless** section, select **Cloud Run functions**.

2. **Create a New Function**
   
   - Click on the **"Create function"** button.
   - In the **Create function** dialog, enter the following:

     - **Environment:** `Cloud Run function`
     - **Function name:** `GCFunction`
     - **Region:** `us-east4`
     - **Trigger type:** `HTTPS`
     - **Authentication:** **Allow unauthenticated invocations**
     - **Memory allocated:** Keep default (in **Runtime, Build, Connections, and Security Settings**)
     - **Autoscaling:** Set **Maximum number of instances** to `5`
     - Click **"Next"**

   - *Note: If prompted to enable required APIs, click **"ENABLE"** when requested.*

## 2. **Deploy the Function**

1. **Use Default Source Code**
   
   - In the **Source code** section for **Inline editor**, use the default `helloHttp` function provided in `index.js`.

2. **Deploy the Function**
   
   - Scroll down and click on the **"Deploy"** button.
   - *Note: While deploying, an icon will display a spinner. It will turn into a green checkmark upon successful deployment.*

## 3. **Test the Function**

1. **Access Testing Section**
   
   - On the function's details dashboard, click on **"TESTING"**.

2. **Trigger the Function**
   
   - In the **Triggering event** field, enter the following:

     ```json
     {"message": "Hello World!"}
     ```

   - Click **"Test the function"**.

3. **Verify the Output**
   
   - In the **Output** field, you should see the message **Hello World!**.
   - In the **Logs** field, a status code of `200` indicates success.
     - *Note: It may take a minute for the logs to appear.*
