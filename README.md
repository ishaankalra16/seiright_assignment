# seiright_assignment
Devops multi region tenancy assignment

# Assignment

Imagine you have a product that has the following components:

* A react-based front-end
* A NodeJS backend
* Postgres
* Message queues (like SQS, Kafka, etc.)

The task is 2-fold:

* Automate a secure, multi-tenant infrastructure that can deploy the infra on a cloud (with special care given to making it easy for cloud migrations)
* Handle privacy sensitive customers who are subject to GDPR, CCPA, etc. (the infra must be deployed in separate regions (like EU) and no data must escape the particular region)

For the take-home, we can restrict to the basic infra setup and some gotchas.
For subsequent steps, we can go deeper on the above (like security practices, logging & Monitoring, special case single-tenant deployments, etc.)

# Directory Structure

- `infrastructure/`: Contains the Infrastructure as Code(IaC) for provisioning resources.
  - `infrastructure.tf.json`: Contains the configuration details for each module such as network, kubernetes etc.
  - `main.tf`: Root terraform project file calling modules from the moduls directory
  - `providers.tf`: Containing the provider configration
  - `versions.tf`: Containing the provider versions.
  - `modules/`: Contains the modules that are being used in the root level terraform project files.
    - `utility_modules/`: Contains a few utility module being used as function inside several modules.
- `service/`: Contains the source code of the applications
  - `node-express-sequelize-postgresql`: Source code for the Node JS backend working with postgres as the database. Code taken from the [repository](https://github.com/bezkoder/node-express-sequelize-postgresql)
  - `redux-toolkit-example-crud-hooks`: Source code for React JS frontend. Code taken from the [repository](https://github.com/bezkoder/redux-toolkit-example-crud-hooks/tree/master)

## Introduction

This repository automates the deployment of a multi-tenant infrastructure on **AWS**. Key functionalities include:

1. **Networking:**
  - Creates a VPC in the specified region.
  - Configures networking (subnets, routing, etc.).

2. **Kubernetes Cluster:**
  - Sets up an EKS cluster with a default node group.
  - Deploys critical infrastructure components such as:
    - Cluster Autoscaler
    - AWS Load Balancer Controller
    - Add-ons: `ebs-csi-driver`, `vpc-cni`, `kube-proxy`, `coredns`

3. **Application Deployment:**
  - Provisions resources for the product: databases (Postgres, RabbitMQ) and services. Configurtion parameters for the service as being passed as environment variables.
  - Exposing services using `nginx-ingress`.
  - Automates SSL certificates via `cert-manager`.

---

# Cloud Migrations

The infrastructure design is simplified for cloud migrations.  


### Example: Migrating from AWS to GCP
- Update the networking and Kubernetes module configurations.
- Minimal or no changes are required for the **service module**, as it relies on a Kubernetes provider configuration.
- Reusable modules (e.g., for databases or services) further ease transitions across clouds and even migrating to cloud specific services.

Notice on how I am using the same service module for provisioning AWS and GCP services.

---

## Defining Module Output Schema

**Why standardize module outputs?*

Consider a scenario where a cloud-specific Postgres database replaces the Kubernetes-provisioned one.
- Create a new module for the cloud database.
- Maintain the same output structure as the existing Postgres module.
- No changes are needed in the consuming modules (e.g., backend service module).

---
## Multi-Tenancy

This IaC design supports **multi-region tenancy** by creating isolated VPCs per tenant. Each tenant can have:

1. **Dedicated Infrastructure:**
  - Separate Terraform workspaces for each tenant.
  - Isolated VPCs with no inter-tenant communication.

2. **Shared EKS Cluster:**
  - Use namespaces to isolate tenants.
  - Enforce network policies to prevent inter-tenant communication.

3. **Shared Database Infrastructure:**
  - Each tenant using same database infrastructure.
  - Database users for each tenant have restricted permissions, limiting access to specific tables/collections.

Other multi-tenancy strategies can be adopted based on organizational needs and application logic.

---

## Handling Privacy-Sensitive Information

To be honest I have not taken this point into consideration for now, since this is a scope that I need to look in the next phase of the assignment. 
I will be happy to discuss this in the interview.

---

## Proof of Execution

The following screenshots demonstrate the execution and results of the setup described in this assignment.

### Directory for Screenshots
All screenshots are stored in the [`screenshots/`](./screenshots/) directory for easy access.  