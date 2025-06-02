variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "vpc_private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway"
  type        = bool
}

variable "vpc_azs" {
  description = "List of Availability Zones"
  type        = list(string)
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "eks_cluster_name" {
  type = string
}

variable "eks_cluster_version" {
  type    = string
  default = "1.29"
}

variable "github_repo" {
  description = "username/repo"
  type        = string
}

variable "tags" {
  type = map(string)
}

