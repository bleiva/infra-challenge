# GitHub Actions Workflows for Infra Deployment

This repository contains a collection of GitHub Actions workflows designed to manage the full lifecycle of an application and its infrastructure on AWS using Terraform, Kubernetes, and Docker.

## Full Deployment

### `full_deploy_dev.yml`
**Purpose**: Orchestrates a complete deployment from scratch, including infrastructure provisioning with Terraform, Kubernetes setup (Traefik, Metrics Server, Prometheus/Grafana), and application deployment with Docker and Helm.  
**Usage**: Trigger this when you need to deploy the entire infrastructure and app stack for the first time or after a full teardown.

**Runs**:
- `tf-apply-dev.yml`
- `k8s-apply-dev.yml`
- `docker-deploy-dev.yml`

---

## Infrastructure Workflows (Terraform)

### `tf-plan-dev.yml`
**Purpose**: Executes `terraform plan` to preview changes in the infrastructure.  
**Trigger**: Pull requests to `main` that include changes to `.tf` or `.tfvars` files in the `tf/` directory.

### `tf-apply-dev.yml`
**Purpose**: Applies infrastructure changes defined by Terraform.  
**Trigger**: Triggered manually, by `full_deploy_dev.yml`, or automatically after merging a PR to `main` that includes infrastructure changes.

---

## Kubernetes Workflows

### `k8s-plan-dev.yml`
**Purpose**: Uses `helm diff` to preview Kubernetes changes, including deployments of Metrics Server, Traefik, Prometheus/Grafana, and the application chart.  
**Trigger**: Pull requests to `main` that modify files under `charts/` or Kubernetes-related workflows in `.github/workflows/k8s-*.yml`.

### `k8s-apply-dev.yml`
**Purpose**: Installs or upgrades Kubernetes components using Helm. This includes Metrics Server, Traefik, Prometheus/Grafana, and the app.  
**Trigger**: Triggered manually, by `full_deploy_dev.yml`, or automatically after merging a PR to `main` that includes changes under `charts/` or `.github/workflows/k8s-*.yml`.

---

## Application Deployment

### `docker-deploy-dev.yml`
**Purpose**: Builds and pushes a Docker image to Amazon ECR and deploys the application to the EKS cluster using Helm.  
**Trigger**: Triggered manually, by `full_deploy_dev.yml`, or automatically when a commit is pushed to `main` that includes changes in `charts/hello-python-chart/` or `app/` directories.  
**Input**: Optional `image_tag` input to specify the image tag.

---

## Notes

- All workflows are configured for the `dev` environment.
- Required secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
- Required environment variables: `ACCOUNT_ID`, `AWS_REGION`, `EKS_CLUSTER_NAME`
- The full deploy workflow waits for each dependent workflow to complete before proceeding.
- To verify deployment success, check the **Show application URL** step output at the end of the full deploy workflow, then open the URL to see the live app response.
