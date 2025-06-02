region      = "us-east-2"
github_repo = "bleiva/infra-challenge"

vpc_name               = "vpc-dev"
vpc_cidr               = "10.203.0.0/16"
vpc_azs                = ["us-east-2a", "us-east-2b", "us-east-2c"]
vpc_private_subnets    = ["10.203.1.0/24", "10.203.2.0/24", "10.203.3.0/24"]
vpc_public_subnets     = ["10.203.101.0/24", "10.203.102.0/24", "10.203.103.0/24"]
vpc_enable_nat_gateway = true

eks_cluster_name    = "eks-dev"
eks_cluster_version = "1.33"

tags = {
  Terraform   = "true"
  Environment = "dev"
  Owner       = "infra-dev-team"
}
