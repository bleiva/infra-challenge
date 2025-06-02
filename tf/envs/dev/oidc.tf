
resource "aws_iam_role" "github_oidc" {
  name = "github-actions-oidc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*"
        }
      }
    }]
  })

  tags = {
    Name        = "github-actions-oidc-role"
    Environment = var.tags["Environment"]
  }
}

resource "aws_iam_policy" "github_oidc_policy" {
  name        = "github-actions-policy"
  description = "Permissions for GitHub Actions via OIDC"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:UpdateClusterConfig",
          "eks:UpdateNodegroupConfig",
          "eks:AccessKubernetesApi"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:*"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_oidc_policy" {
  role       = aws_iam_role.github_oidc.name
  policy_arn = aws_iam_policy.github_oidc_policy.arn
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]

  tags = {
    Name        = "github-actions"
    Environment = var.tags["Environment"]
  }
}
