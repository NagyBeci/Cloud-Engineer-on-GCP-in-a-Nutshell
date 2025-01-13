# GCP Effective Usage Guide

## 1. **Create a Pub/Sub Topic**

### 1.1 Navigate to Pub/Sub
- Open the [Google Cloud Console](https://console.cloud.google.com/).
- Click the **Navigation menu** (☰) and select **View All Products**.
- Under the **Analytics** section, choose **Pub/Sub > Topics**.

### 1.2 Create the Topic
- Click **"Create topic"**.
- In the **Create a topic** dialog:
  - **Topic ID:** `MyTopic`
  - Leave other fields at default.
- Click **"Create"**.

## 2. **Add a Subscription**

### 2.1 Navigate to Subscriptions
- In the **Pub/Sub > Topics** page, locate `MyTopic`.
- Click the three-dot icon (⋮) next to `MyTopic` and select **"Create subscription"**.

### 2.2 Create the Subscription
- In the **Add subscription to topic** dialog:
  - **Subscription name:** `MySub`
  - **Delivery type:** Select **Pull**.
  - Leave other options at default.
- Click **"Create"**.

## 3. **Publish a Message to the Topic**

### 3.1 Navigate to the Topic
- Go back to **Pub/Sub > Topics** and click on `MyTopic`.

### 3.2 Publish the Message
- In the **Topic details** page, select the **Messages** tab.
- Click **"Publish Message"**.
- **Message:** `Hello World`
- Click **"Publish"**.

## 4. **View the Message**

### 4.1 Pull the Message via Subscription
- Open **Cloud Shell** from the [Google Cloud Console](https://console.cloud.google.com/).
- Run the following command to pull the message:
  ```bash
  gcloud pubsub subscriptions pull --auto-ack MySub
  ```
- **Output Example:**
  ```
  DATA: Hello World
  ```

## Summary
- **Created:** Pub/Sub topic `MyTopic`.
- **Added:** Subscription `MySub` with Pull delivery.
- **Published:** Message "Hello World" to `MyTopic`.
- **Pulled:** Message from `MySub` using Cloud Shell.

*You have successfully set up Pub/Sub by creating a topic and subscription, publishing a message, and retrieving it using the subscription.*
```