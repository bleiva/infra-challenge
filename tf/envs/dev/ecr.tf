# Create ECR repository to upload app image
resource "aws_ecr_repository" "hello_python" {
  name                 = "hello-python-app-${var.tags["Environment"]}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = var.tags
}

resource "aws_secretsmanager_secret" "ecr_repo_url" {
  name = "ecr-repo-url-${var.tags["Environment"]}"
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "ecr_repo_url_value" {
  secret_id = aws_secretsmanager_secret.ecr_repo_url.id
  secret_string = jsonencode({
    url = aws_ecr_repository.hello_python.repository_url
  })
}
