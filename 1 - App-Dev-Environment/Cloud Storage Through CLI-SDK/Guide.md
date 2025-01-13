# Google Cloud Storage Workflow Guide

## 1. Activate Cloud Shell
Activate the Cloud Shell by clicking the **Activate Cloud Shell** icon at the top of the Google Cloud Console.

## 2. List Authenticated Accounts
Run the following command to list authenticated accounts:
`gcloud auth list`

## 3. View Current Project Configuration
Use this command to view the current project configuration:
`gcloud config list project`

## 4. Set the Project Region
Set the default project region to `us-central1` using:
`gcloud config set compute/region us-central1`

## 5. Create a Storage Bucket
Create a Cloud Storage bucket using:
`gcloud storage buckets create gs://qwiklabs-gcp-03-0672c36aadb5-152025`

## 6. Download an Image to Cloud Shell
Download the image `Ada_Lovelace_portrait.jpg` to the Cloud Shell environment:
`curl https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Ada_Lovelace_portrait.jpg/800px-Ada_Lovelace_portrait.jpg --output ada.jpg`

## 7. Upload the Image to the Bucket
Upload the downloaded image to the Cloud Storage bucket:
`gcloud storage cp ada.jpg gs://qwiklabs-gcp-03-0672c36aadb5-152025`

## 8. Remove the Local Image File
Remove the local copy of the image from the Cloud Shell environment:
`rm ada.jpg`

## 9. Download the Image from the Bucket to Cloud Shell
Download the image from the bucket back to the Cloud Shell environment:
`gcloud storage cp gs://qwiklabs-gcp-03-0672c36aadb5-152025/ada.jpg .`

## 10. Create a Folder and Copy the Image into It
Copy the image into a newly created folder within the Cloud Storage bucket:
`gcloud storage cp gs://qwiklabs-gcp-03-0672c36aadb5-152025/ada.jpg gs://qwiklabs-gcp-03-0672c36aadb5-152025/image-folder/`

## 11. List Bucket Contents
List the contents of the Cloud Storage bucket:
`gcloud storage ls gs://qwiklabs-gcp-03-0672c36aadb5-152025`

## 12. View Details of the Uploaded Image
View detailed information about the uploaded image:
`gcloud storage ls -l gs://qwiklabs-gcp-03-0672c36aadb5-152025/ada.jpg`

## 13. Grant Read Permission to All Users
Grant read access to all users for the uploaded image:
`gsutil acl ch -u AllUsers:R gs://qwiklabs-gcp-03-0672c36aadb5-152025/ada.jpg`
