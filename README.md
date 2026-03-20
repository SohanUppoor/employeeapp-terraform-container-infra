# 🚀 Employee Management App – Containerized Infrastructure (AWS ECS + Terraform)

## 📌 Overview

This repository provisions a **modern containerized infrastructure** for the Employee Management Application using **Terraform** and **AWS ECS (Fargate)**.

This project is an evolution of a traditional EC2-based deployment to a **cloud-native, container-based architecture**, demonstrating real-world DevOps practices.

The application consists of:

* **Frontend**: React (Vite) served via NGINX
* **Backend**: Spring Boot (Java 17)
* **Database**: MySQL (AWS RDS)

---

## 🏗️ Architecture

The infrastructure uses **Amazon ECS (Fargate)** to run containerized services behind an Application Load Balancer.

### High Level Flow

```
User
  ↓
Application Load Balancer (Public)
  ↓
-----------------------------------------
|                                       |
Frontend Service (ECS Fargate)     Backend Service (ECS Fargate)
(NGINX - Port 80)                 (Spring Boot - Port 8081)
  ↓                                       ↓
            Amazon RDS (MySQL - Private Subnet)
```

---

## 🔧 Infrastructure Components

### 🌐 VPC & Networking

* Custom VPC with CIDR block
* Public subnets (for ALB & ECS tasks)
* Private subnets (for RDS)
* Internet Gateway
* Route Tables

> 💡 ECS tasks are deployed in **public subnets with public IPs** to avoid NAT Gateway costs (free-tier optimization).

---

### ⚖️ Application Load Balancer (ALB)

* Internet-facing ALB
* Path-based routing:

  * `/` → Frontend service
  * `/api/*` → Backend service
* Health checks:

  * Frontend → `/`
  * Backend → `/actuator/health` (or `/api/employees`)

---

### 🐳 Amazon ECS (Fargate)

* ECS Cluster for container orchestration
* Two services:

  * **Frontend Service**
  * **Backend Service**
* Task Definitions define:

  * CPU & Memory
  * Container images from ECR
  * Port mappings

Benefits:

* No server management
* Scalable container deployment
* High availability

---

### 📦 Amazon ECR (Elastic Container Registry)

* Stores Docker images:

  * `employee-frontend`
  * `employee-backend`
* Integrated with CI/CD pipeline

---

### 🛢️ Amazon RDS (MySQL)

* Deployed in private subnets
* Not publicly accessible
* Used by backend service for persistence

---

### 🔐 IAM Roles & Security

* ECS Task Execution Role for pulling images from ECR
* Security Groups:

  * ALB → public access (HTTP)
  * ECS → accepts traffic only from ALB
  * RDS → accepts traffic only from ECS

---

## 🔄 CI/CD Integration

Application images are built and pushed via **GitHub Actions**:

1. Build Docker images (frontend & backend)
2. Push images to Amazon ECR
3. ECS services pull latest images during deployment

---

## ⚙️ Deployment Steps

Initialize Terraform:

```
terraform init
```

Preview changes:

```
terraform plan
```

Apply infrastructure:

```
terraform apply
```

Destroy infrastructure (optional):

```
terraform destroy
```

---

## 🔐 Security Considerations

* RDS is deployed in **private subnets**
* ECS services are accessed **only via ALB**
* Security groups restrict traffic between components
* No direct public access to backend or database

---

## 📈 Key Benefits

* Containerized deployment using Docker
* Fully managed compute with ECS Fargate
* Improved scalability and flexibility
* Clean separation of frontend and backend services
* Infrastructure as Code using Terraform
* CI/CD integration with ECR

---

## 🔮 Future Improvements

* HTTPS with AWS ACM
* Auto Scaling policies for ECS services
* AWS Secrets Manager for DB credentials
* CloudWatch monitoring & logging
* Blue/Green deployments
* WAF for enhanced security

---

## 👨‍💻 Author

Created as part of a **Cloud & DevOps portfolio project** demonstrating:

* Infrastructure as Code (Terraform)
* Containerization (Docker)
* Orchestration (AWS ECS)
* CI/CD (GitHub Actions)

---

## ⭐ Final Note

This project showcases a **real-world transition from traditional infrastructure to cloud-native architecture**, focusing on scalability, maintainability, and modern DevOps practices.
