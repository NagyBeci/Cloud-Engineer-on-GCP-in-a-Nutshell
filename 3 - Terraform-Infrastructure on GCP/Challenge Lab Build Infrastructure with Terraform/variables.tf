variable "project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
  default     = "qwiklabs-gcp-03-a0ec830f741c"  # Replace with your project ID
}

variable "region" {
  description = "The region to deploy resources to"
  type        = string
  default     = "us-west1"
}

variable "zone" {
  description = "The zone to deploy resources to"
  type        = string
  default     = "us-west1-a"
}