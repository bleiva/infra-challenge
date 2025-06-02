# Get account id
data "aws_caller_identity" "current" {}

# Get information about the cluster to create roles/users
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

# Get cluster name
data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

# Create VPC 
module "vpc" {
  source = "../../modules/vpc"

  vpc_name           = var.vpc_name
  cidr               = var.vpc_cidr
  azs                = var.vpc_azs
  private_subnets    = var.vpc_private_subnets
  public_subnets     = var.vpc_public_subnets
  enable_nat_gateway = var.vpc_enable_nat_gateway
  tags               = var.tags
}

# Create EKS
module "eks" {
  source = "../../modules/eks"

  cluster_name                   = var.eks_cluster_name
  cluster_version                = var.eks_cluster_version
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnet_ids
  cluster_endpoint_public_access = true
  tags                           = var.tags
}


module "eks_aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "20.36.0"

  depends_on = [module.eks]

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/github-actions-oidc-role"
      username = "github-actions"
      groups   = ["system:masters"]
    }
  ]
}
