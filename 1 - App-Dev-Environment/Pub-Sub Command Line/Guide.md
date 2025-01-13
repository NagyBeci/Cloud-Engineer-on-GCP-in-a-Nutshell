# GCP Effective Usage Guide

## 1. **Pub/Sub Basics**

- **Pub/Sub** is an asynchronous global messaging service.
- **Topics:** Shared channels where publishers send messages.
- **Publishers:** Push messages to a **topic**.
- **Subscribers:** Create **subscriptions** to receive messages from a **topic**.
- **Workflow:** Producers publish to topics; consumers subscribe to receive messages.

## 2. **Set Up Pub/Sub Topics**

### 2.1 Create Topics

- Open **Cloud Shell** from the [Google Cloud Console](https://console.cloud.google.com/).
- Run the following commands to create topics:

  ```bash
  gcloud pubsub topics create myTopic
  gcloud pubsub topics create Test1
  gcloud pubsub topics create Test2
  ```

### 2.2 List Topics

- Verify the created topics:

  ```bash
  gcloud pubsub topics list
  ```

## 3. **Manage Pub/Sub Subscriptions**

### 3.1 Create Subscriptions

- Create a subscription `mySubscription` for `myTopic`:

  ```bash
  gcloud pubsub subscriptions create --topic myTopic mySubscription
  ```

- Add two more subscriptions:

  ```bash
  gcloud pubsub subscriptions create --topic myTopic Test1
  gcloud pubsub subscriptions create --topic myTopic Test2
  ```

### 3.2 List Subscriptions

- View subscriptions for `myTopic`:

  ```bash
  gcloud pubsub topics list-subscriptions myTopic
  ```

### 3.3 Delete Subscriptions

- Remove `Test1` and `Test2` subscriptions:

  ```bash
  gcloud pubsub subscriptions delete Test1
  gcloud pubsub subscriptions delete Test2
  ```

## 4. **Publish and Pull Messages**

### 4.1 Publish Messages

- Publish a single message:

  ```bash
  gcloud pubsub topics publish myTopic --message "Hello"
  ```

- Publish additional messages:

  ```bash
  gcloud pubsub topics publish myTopic --message "Publisher's name is <YOUR NAME>"
  gcloud pubsub topics publish myTopic --message "Publisher likes to eat <FOOD>"
  gcloud pubsub topics publish myTopic --message "Publisher thinks Pub/Sub is awesome"
  ```

### 4.2 Pull Messages

- Pull a single message:

  ```bash
  gcloud pubsub subscriptions pull mySubscription --auto-ack
  ```

  *Note: Only one message is retrieved per pull without specifying a limit.*

- Pull multiple messages by repeating the pull command:

  ```bash
  gcloud pubsub subscriptions pull mySubscription --auto-ack
  gcloud pubsub subscriptions pull mySubscription --auto-ack
  gcloud pubsub subscriptions pull mySubscription --auto-ack
  ```

- Attempt to pull when no messages are left:

  ```bash
  gcloud pubsub subscriptions pull mySubscription --auto-ack
  ```

  *Expected Output: No messages available.*

## 5. **Pull All Messages from Subscriptions**

### 5.1 Publish More Messages

- Add new messages to `myTopic`:

  ```bash
  gcloud pubsub topics publish myTopic --message "Publisher is starting to get the hang of Pub/Sub"
  gcloud pubsub topics publish myTopic --message "Publisher wonders if all messages will be pulled"
  gcloud pubsub topics publish myTopic --message "Publisher will have to test to find out"
  ```

### 5.2 Pull Multiple Messages at Once

- Use the `--limit` flag to pull multiple messages in one command:

  ```bash
  gcloud pubsub subscriptions pull mySubscription --auto-ack --limit=3
  ```

  *This retrieves up to three messages in a single pull.*

## 6. **Summary**

- **Created Topics:** `myTopic`, `Test1`, `Test2`.
- **Created Subscriptions:** `mySubscription` (to `myTopic`), `Test1`, `Test2`.
- **Published Messages:** Multiple messages to `myTopic`.
- **Pulled Messages:** Retrieved messages using `mySubscription` with and without limits.

*You have successfully set up Pub/Sub by creating topics and subscriptions, publishing messages, and retrieving them using subscriptions.*
```