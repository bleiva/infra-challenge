# infra-challenge

This repository provides a complete DevOps pipeline for deploying infrastructure and applications to AWS using IaC and CI/CD best practices.

It includes:

- **Terraform** for infrastructure provisioning (VPC, EKS, IAM, etc.)
- **Helm** for Kubernetes application packaging and deployment
- **Python** demo app (`hello-python-app`) with Docker
- **GitHub Actions** for CI/CD automation

---

## Table of Contents

- [📖 Overview](#overview)
- [📁 Project Structure](#project-structure)
- [🚀 Deployment Guide](#deployment-guide)
- [🏗️ Terraform Stack](#terraform-stack)
- [📦 Kubernetes Stack](#kubernetes-stack)
- [⚙️ CI/CD Workflows](#cicd-workflows)
- [📂 Terraform Environment: dev](tf/envs/dev/README.md)
- [📂 App Chart Documentation](charts/hello-python-chart/README.md)
- [📂 App README](app/hello-python-app/README.md)
- [📂 GitHub Actions Workflows](.github/workflows/README.md)
- [🛠️ Challenges and Improvements](#challenges-and-improvements)

---

## Project Structure

```plaintext
infra-challenge/
├── app/                       # Sample Python application
│   └── hello-python-app/     # Flask "Hello World" app with Docker
├── charts/                   # Helm charts for Kubernetes deployment
│   ├── hello-python-chart/   # Application Helm chart
├── docs/                     # General deployment documentation
│   └── DEPLOYMENT.md             # Step-by-step deployment guide
├── tf/                       # Terraform codebase
│   ├── envs/                 # Environment-specific configuration (e.g., dev)
│   │   └── dev/
│   ├── modules/              # Reusable Terraform modules
│   │   ├── eks/              # EKS module
│   │   └── vpc/              # VPC module
│   └── README.md
├── utils/                    # Supporting files for Terraform policies
│   └── TerraformEKSFullAccess.json
├── .github/                  # GitHub Actions workflows
│   └── workflows/
└── README.md
```

---

## Deployment Guide

**💡 Start Here!**

If you're excited to get this infrastructure running and see it all in action, the Deployment Guide is your magic ticket.

👉 [Follow the Deployment Guide →](docs/DEPLOYMENT.md)

Let’s get your cloud up and running in no time!

---

## Terraform Stack

Terraform is used to provision the entire AWS infrastructure. It manages:

| Component          | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| VPC               | Public/private subnets, NAT Gateway                                          |
| EKS               | Production-grade Kubernetes cluster via `terraform-aws-eks` module          |
| ECR               | Docker image registry for the app                                           |
| Secrets Manager   | Storage for ECR URL and other secrets                                        |
| GitHub OIDC Auth  | IAM Role and Policy for GitHub Actions to assume via OpenID Connect         |

Infrastructure is modularized and environment-specific. See [tf/envs/dev/README.md](tf/envs/dev/README.md) for details.

---

## Kubernetes Stack

The Kubernetes cluster includes optional and essential components:

| Component     | Tool                  | Installation Method                |
|---------------|------------------------|------------------------------------|
| Traefik       | Ingress Controller     | Helm chart                         |
| Prometheus    | Monitoring             | `kube-prometheus-stack` Helm chart |
| Grafana       | Dashboards             | Part of Prometheus chart           |
| Metrics Server| Pod Metrics            | Manifest YAML                      |
| ExternalDNS   | DNS Automation (opt.)  | Helm chart                         |

---

## CI/CD Workflows

CI/CD is powered by **GitHub Actions**, split by purpose:

- **Terraform Plan** (on PR)
- **Terraform Apply** (push to main/manual)
- **K8s Plan** (on PR)
- **K8s Apply** (push to main/manual)
- **Full Deploy** (recommended: deploys infra, k8s, and app)
- **Build & Deploy App** (push to main/manual)

Each workflow is documented in [GitHub Actions Readme](.github/workflows/README.md).

---

# Challenges and Improvements

This solution aims to fully automate the provisioning and deployment lifecycle of an application on AWS using modern DevOps tools. The use of GitHub Actions for CI/CD provides visibility, repeatability, and an easy way to manage environments. The architecture leverages Terraform for infrastructure-as-code and Helm for Kubernetes resources.

## Challenges encountered:

- Ensuring that the different workflows were properly triggered by the correct file changes and branches.
- Managing secret configuration securely in GitHub while supporting local and CI/CD execution.
- Making sure the app was reachable through the correct Load Balancer settings and Traefik setup.

## Potential Improvements:

- The EKS cluster currently uses a public endpoint. For production, it's recommended to use private access or tunnel via a bastion host. Running GitHub Runners in k8s is another great option.
- Deploy a domain name via Terraform to provide a production-like access point.
- Add Grafana dashboards to monitor app health and configure alerts for outages.
- Improve cost efficiency using Karpenter or EC2 Spot instances for autoscaling.
- Refine security groups to only allow necessary access rather than using module defaults.
- Integrate centralized logging with CloudWatch, Loki, or a similar solution for easier troubleshooting.
- Use stricter IAM policies for GitHub users deploying infrastructure. While a role is used for Kubernetes deployment, Terraform should also leverage scoped-down roles or assume-role chaining for added security.
- Introduce application versioning with Git tags and maintain a `CHANGELOG.md` to track changes between releases.
- Analyse to use ALB or NLB for traefik instead of Classic Load Balancer in AWS.
