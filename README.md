# Cloud Engineering on GCP in a Nutshell

<!-- Badges Section -->
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Language: Markdown](https://img.shields.io/badge/Docs-Markdown-success.svg)](https://shields.io/)
[![Build Status](https://github.com/NagyBeci/Cloud-Engineer-on-GCP-in-a-Nutshell/actions/workflows/ci-build.yml/badge.svg)](https://github.com/NagyBeci/Cloud-Engineer-on-GCP-in-a-Nutshell/actions)
[![Terraform](https://img.shields.io/badge/IaC-Terraform-844FBA.svg?logo=terraform)](https://www.terraform.io/)
[![GCP Project](https://img.shields.io/badge/Cloud-GCP-4285F4.svg?logo=google-cloud)](https://cloud.google.com/)

Welcome to **Cloud Engineering on GCP in a Nutshell**, a repository dedicated to showcasing **best practices** and **real-world use cases** on Google Cloud Platform (GCP). Each folder includes its own `Guide.md` file, where you’ll find step-by-step instructions, detailed explanations, and code snippets.

## Table of Contents
1. [Set Up an App and Dev Environment](#1-set-up-an-app-and-dev-environment)
2. [Develop Your Google Cloud Network](#2-develop-your-google-cloud-network)
3. [Build Infrastructure with Terraform on Google Cloud](#3-build-infrastructure-with-terraform-on-google-cloud)
4. [Getting Started](#getting-started)
5. [How to Contribute](#how-to-contribute)
6. [License](#license)
7. [Feedback](#feedback)

---

## 1. Set Up an App and Dev Environment
- **Focus**: Enhanced VM usage, Cloud SQL, and Cloud Storage integration.
- **Key Topics**:
  - Creating and configuring VM instances for development tasks.
  - Setting up Cloud SQL databases and linking them to your VMs.
  - Managing Cloud Storage buckets for files and data backups.
  - Networking basics to connect VMs, databases, and storage securely.
- **Best Practices**: Discover how to structure your dev environment for scalability, security, and smooth collaboration across different services.
- **See `Guide.md`**: The `Guide.md` includes practical examples on bridging compute resources, data storage, and monitoring.

---

## 2. Develop Your Google Cloud Network
- **Focus**: Advanced monitoring, health checks, and load balancing design.
- **Key Topics**:
  - Using Google Cloud Monitoring to track performance and detect issues.
  - Configuring health checks to maintain availability and resiliency.
  - Designing networks and subnets for optimized traffic flow.
  - Leveraging load balancers to direct users to the nearest functional VM.
- **Best Practices**: Improve your infrastructure’s reliability by monitoring real-time metrics and automating traffic routing based on health checks.
- **See `Guide.md`**: The `Guide.md` file here gives hands-on examples of setting up monitoring dashboards, alerts, and multi-region load balancing.

---

## 3. Build Infrastructure with Terraform on Google Cloud
- **Focus**: Applying Infrastructure-as-Code (IaC) principles to all the above sections using Terraform.
- **Key Topics**:
  - Terraform basics: variables, `main.tf`, modules, and the HashiCorp Configuration Language (HCL).
  - Creating, updating, and deleting GCP resources through Terraform.
  - Structuring configurations for modular, reusable code.
  - Managing Terraform state for versioned and collaborative workflows.
- **Best Practices**: Learn how to minimize manual tasks, maintain consistency, and streamline resource provisioning across multiple environments.
- **See `Guide.md`**: Review the `Guide.md` to walk through real-world Terraform configurations and scripts that unify everything you learned in the earlier sections.

---

## Getting Started

1. **Clone the Repo**:
   ```bash
   git clone https://github.com/NagyBeci/Cloud-Engineer-on-GCP-in-a-Nutshell.git
   cd Cloud-Engineer-on-GCP-in-a-Nutshell
