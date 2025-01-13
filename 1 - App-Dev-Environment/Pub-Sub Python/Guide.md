# GCP Effective Usage Guide

## 1. **Set Up Python Virtual Environment**

### 1.1 Install `virtualenv`

```bash
sudo apt-get install -y virtualenv
```

### 1.2 Create and Activate Virtual Environment

```bash
python3 -m venv venv
source venv/bin/activate
```

## 2. **Install Pub/Sub Client Library**

```bash
pip install --upgrade google-cloud-pubsub
```

## 3. **Get Sample Code**

```bash
git clone https://github.com/googleapis/python-pubsub.git
cd python-pubsub/samples/snippets
```

## 4. **Create Pub/Sub Topics**

### 4.1 Create Topics

```bash
gcloud pubsub topics create myTopic
gcloud pubsub topics create Test1
gcloud pubsub topics create Test2
```

### 4.2 List Topics

```bash
gcloud pubsub topics list
```

## 5. **Manage Pub/Sub Subscriptions**

### 5.1 Create Subscriptions

```bash
gcloud pubsub subscriptions create --topic myTopic mySubscription
gcloud pubsub subscriptions create --topic myTopic Test1
gcloud pubsub subscriptions create --topic myTopic Test2
```

### 5.2 List Subscriptions

```bash
gcloud pubsub topics list-subscriptions myTopic
```

### 5.3 Delete Subscriptions

```bash
gcloud pubsub subscriptions delete Test1
gcloud pubsub subscriptions delete Test2
```

## 6. **Publish Messages**

### 6.1 Publish a Single Message

```bash
gcloud pubsub topics publish myTopic --message "Hello"
```

### 6.2 Publish Multiple Messages

```bash
gcloud pubsub topics publish myTopic --message "Publisher's name is <YOUR NAME>"
gcloud pubsub topics publish myTopic --message "Publisher likes to eat <FOOD>"
gcloud pubsub topics publish myTopic --message "Publisher thinks Pub/Sub is awesome"
```

## 7. **View Messages**

### 7.1 Pull a Single Message

```bash
gcloud pubsub subscriptions pull mySubscription --auto-ack
```

*Note: Only one message is retrieved per pull without specifying a limit.*

### 7.2 Pull Multiple Messages

```bash
gcloud pubsub subscriptions pull mySubscription --auto-ack --limit=3
```

*This retrieves up to three messages in a single pull.*

### 7.3 Stop Pulling Messages

Press `Ctrl + C` to stop listening.

## 8. **Summary**

- **Virtual Environment:** Created and activated.
- **Client Library:** Installed `google-cloud-pubsub`.
- **Topics:** Created `myTopic`, `Test1`, `Test2`.
- **Subscriptions:** Created `mySubscription`, `Test1`, `Test2`.
- **Publishing:** Sent multiple messages to `myTopic`.
- **Pulling:** Retrieved messages using `mySubscription` with and without limits.

*You have successfully set up Pub/Sub by creating topics and subscriptions, publishing messages, and retrieving them using subscriptions.*
```