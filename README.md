# Automated AWS Network Infrastructure with Terraform

## 📌 Project Overview
This repository contains Terraform configuration files to deploy a professional-grade VPC environment on AWS. It demonstrates infrastructure automation, modularity through variables, and secure state management.

## 🏗️ Architecture
The project automates the deployment of:
* **Custom VPC:** Isolated network with a private CIDR block.
* **Public Subnet:** Configured for external-facing resources.
* **EC2 Web Server:** A virtual compute instance running in the public subnet.
* **Security Groups:** Firewall rules allowing SSH (Port 22) and HTTP (Port 80) access.

## 🛠️ Technical Features
* **IaC (Infrastructure as Code):** Managed via HashiCorp Configuration Language (HCL).
* **Remote Backend:** State files are stored securely in an **Amazon S3** bucket with **DynamoDB** state locking (configured in `main.tf`).
* **Variables:** Environment-specific settings are abstracted into `variables.tf` for reusability.
* Modular Architecture: Reorganized infrastructure into reusable modules (/modules/vpc) to support scalability and cleaner code management.

## 🚀 Deployment Instructions
1. Clone this repository to your local environment.
2. Initialize the working directory:
   ```bash
   terraform init
