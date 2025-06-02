
# infra-challenge `dev` Environment

This Terraform environment sets up the development-stage infrastructure for the `infra-challenge` project. It provisions a complete VPC and EKS cluster, alongside GitHub Actions integration and a secure setup using AWS Secrets Manager and ECR.

---

## Project Highlights

- VPC with NAT Gateway and subnetting across three AZs
- EKS cluster (v1.29+) with public endpoint access
- ECR and Secrets Manager provisioning
- IAM roles for GitHub OIDC authentication

---

## Modules Used

### VPC

| Name                   | Description                          |
|------------------------|--------------------------------------|
| `vpc` module           | Provisions networking infrastructure including VPC, subnets, and NAT Gateway |

### EKS

| Name                   | Description                          |
|------------------------|--------------------------------------|
| `eks` module           | Creates and configures an Amazon EKS cluster with private subnet integration |
| `eks_aws_auth`         | Manages the aws-auth configmap to grant access to GitHub Actions role |

---

## Input Variables

| Name                    | Description                         | Type             | Required | Default  |
|-------------------------|-------------------------------------|------------------|----------|----------|
| `vpc_name`              | Name of the VPC                     | `string`         | yes      | –        |
| `vpc_cidr`              | CIDR block for the VPC              | `string`         | yes      | –        |
| `vpc_private_subnets`   | Private subnet CIDRs                | `list(string)`   | yes      | –        |
| `vpc_public_subnets`    | Public subnet CIDRs                 | `list(string)`   | yes      | –        |
| `vpc_enable_nat_gateway`| Enable NAT Gateway                  | `bool`           | yes      | –        |
| `vpc_azs`               | List of Availability Zones          | `list(string)`   | yes      | –        |
| `region`                | AWS region                          | `string`         | yes      | –        |
| `eks_cluster_name`      | EKS cluster name                    | `string`         | yes      | –        |
| `eks_cluster_version`   | Kubernetes version for EKS          | `string`         | no       | `1.33`   |
| `github_repo`           | GitHub repository for OIDC auth     | `string`         | yes      | –        |
| `tags`                  | Common resource tags                | `map(string)`    | yes      | –        |

---

## Outputs

| Name                   | Description                                |
|------------------------|--------------------------------------------|
| `hello_python_ecr_url` | URL of the ECR repository for the app image |

---

## Notes

- Remote state backend is configured in S3 with locking.
- IAM role and policy for GitHub Actions is configured with secure OIDC federation.
- Secrets Manager stores the ECR URL as a secret.

Refer to the root [`README.md`](../../README.md) for full context and project-level documentation.
