
# Terraform Infrastructure - `dev` Environment

This Terraform configuration provisions the base infrastructure needed to deploy and operate Kubernetes workloads in a development environment.

It includes:
- A fully configured **VPC** with public/private subnets across three Availability Zones.
- A managed **Amazon EKS** (Elastic Kubernetes Service) cluster.
- Integration with **GitHub Actions OIDC** for secure CI/CD deployments.
- Remote **Terraform state management in S3** with locking enabled.

---

## Infrastructure Components

### VPC
Creates a virtual network with:

- CIDR block: 10.203.0.0/16
- 3 public and 3 private subnets
- NAT Gateway for internet access from private subnets

This VPC setup follows the AWS Well-Architected Framework by ensuring that all compute resources are placed in private subnets, avoiding direct internet exposure. Only the load balancer is assigned to public subnets, while the rest of the infrastructure accesses the internet through a NAT Gateway, enforcing a secure and scalable network design.

### EKS Cluster
Deploys an EKS cluster with:
- Name: `eks-dev`
- Kubernetes version: `1.33`
- Managed Node Groups using `t3.medium` instances

> For practicality during development, `cluster_endpoint_public_access` is set to `true` to allow direct `kubectl` access and GitHub Actions deployment without a bastion or runner inside the cluster.  
> ⚠️ In a production environment, it is **strongly recommended** to restrict public access and instead use **GitHub Actions self-hosted runners** inside the VPC or a **bastion host** for secure administrative access.

### IAM & GitHub Actions
Sets up IAM roles and policies to enable GitHub Actions to assume an OIDC role with permissions for:
- Managing EKS
- Accessing ECR
- Reading from Secrets Manager

---

## Remote State
State is stored in an encrypted S3 bucket with locking:
```hcl
backend "s3" {
  bucket       = "terraform-state-<DATE>"
  key          = "dev/terraform.tfstate"
  region       = "us-east-2"
  encrypt      = true
  use_lockfile = true
}
```

---

## Project Structure

```text
tf/
├── envs/
│   └── dev/             # Environment-specific variables and backend
├── modules/
│   ├── vpc/             # Reusable VPC module
│   └── eks/             # Reusable EKS module
```

---

## Requirements
- Terraform ≥ 1.10
- AWS CLI configured
- S3 bucket
