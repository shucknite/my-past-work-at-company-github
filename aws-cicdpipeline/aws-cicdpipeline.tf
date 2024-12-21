resource "aws_codecommit_repository" "frontend_repo" {
  repository_name = "frontend-repo"
  description     = "Repository for frontend code"
}

resource "aws_codecommit_repository" "backend_repo" {
  repository_name = "backend-repo"
  description     = "Repository for backend code"
}


# resource "null_resource" "push_frontend" {
#   provisioner "local-exec" {
#     command = <<EOT
#       cd ./frontend
#       git init
#       git remote add origin $(aws codecommit get-repository --repository-name frontend --query repositoryMetadata.cloneUrlHttp --output text)
#       git add .
#       git commit -m "Initial commit for frontend"
#       git push -u origin main
#     EOT
#   }

#   depends_on = [aws_codecommit_repository.frontend]
# }

# resource "null_resource" "push_backend" {
#   provisioner "local-exec" {
#     command = <<EOT
#       cd ./backend
#       git init
#       git remote add origin $(aws codecommit get-repository --repository-name backend --query repositoryMetadata.cloneUrlHttp --output text)
#       git add .
#       git commit -m "Initial commit for backend"
#       git push -u origin main
#     EOT
#   }

#   depends_on = [aws_codecommit_repository.backend]
# }

resource "aws_iam_role" "codecommit_role" {
  name = "codecommit-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com" # Replace with relevant service or user
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "codecommit_policy" {
  name = "CodeCommitAccessPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codecommit:GitPull",
          "codecommit:GitPush",
          "codecommit:CreateRepository"
        ],
        # Resource = [
        #   aws_codecommit_repository.frontend_repo.arn,
        #   aws_codecommit_repository.backend_repo.arn,
        # ]
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codecommit_role_attach" {
  role       = aws_iam_role.codecommit_role.name
  policy_arn = aws_iam_policy.codecommit_policy.arn
}


resource "null_resource" "push_frontend_code" {
  provisioner "local-exec" {
    command = <<EOT
      cd frontend
      git init 
      git remote add origin https://git-codecommit.${var.aws_region}.amazonaws.com/v1/repos/${aws_codecommit_repository.frontend_repo.repository_name}
      git add .
      git commit -m "Initial commit for frontend"
      git push origin main
    EOT
  }

  depends_on = [aws_codecommit_repository.frontend_repo]

  triggers = {
    frontend_code_push = "${timestamp()}"
  }
}

resource "null_resource" "push_backend_code" {
  provisioner "local-exec" {
    command = <<EOT
    cd ./backend
    git init
    git remote add origin https://git-codecommit.us-east-1.amazonaws.com/v1/repos/backend-repo
    echo "Sample backend code" > README.md
    git add .
    git commit -m "Initial commit for backend"
    git branch -M main
    git push -u origin main
  EOT
  }

  depends_on = [aws_codecommit_repository.backend_repo]

  triggers = {
    backend_code_push = "${timestamp()}"
  }
}

resource "aws_codebuild_project" "frontend" {
  name         = "frontend"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type     = "CODECOMMIT"
    location = aws_codecommit_repository.frontend_repo.clone_url_http
  }
}


resource "aws_codebuild_project" "backend" {
  name         = "backend"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type     = "CODECOMMIT"
    location = aws_codecommit_repository.backend_repo.clone_url_http
  }
}

resource "aws_iam_role" "codebuild" {
  name_prefix = "codebuild-role-"
  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          Service: "codebuild.amazonaws.com",
        },
        Action: "sts:AssumeRole",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "codebuild_code_commit_access" {
  role       = aws_iam_role.codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}


