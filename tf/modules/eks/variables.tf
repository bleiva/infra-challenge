variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_version" {
  type        = string
  default     = "1.29"
  description = "Kubernetes version to use"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the EKS cluster will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for EKS nodes"
}

variable "cluster_endpoint_public_access" {
  description = "Enable public access to the EKS cluster endpoint"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDRs that can access the EKS cluster endpoint publicly"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_endpoint_private_access" {
  description = "Enable private access to the EKS cluster endpoint"
  type        = bool
  default     = true
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to EKS and node group resources"
}
