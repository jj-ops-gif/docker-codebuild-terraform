terraform {
    required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "~> 3.27"
      }
    }
    required_version = ">= 0.14.9"
}

provider "aws" {
  region = var.region
  profile = "default"
  default_tags {
      tags = var.prop_tags
  }
}

# simple codebuild project
resource "aws_codebuild_project" "codebuild_project" {
  name          = var.codebuild_name
  description   = "Codebuild demo with Terraform"
  build_timeout = "120"
  service_role = aws_iam_role.role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type            = "GITHUB"
    location        = lookup(var.codebuild_params, "GIT_REPO")
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  environment {
    image                       = lookup(var.codebuild_params, "IMAGE")
    type                        = lookup(var.codebuild_params, "TYPE")
    compute_type                = lookup(var.codebuild_params, "COMPUTE_TYPE")
    image_pull_credentials_type = lookup(var.codebuild_params, "CRED_TYPE")
    privileged_mode             = true

    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status = "DISABLED"
    }
  }
}

resource "aws_codebuild_webhook" "example" {
  project_name = aws_codebuild_project.codebuild_project.name
  build_type   = "BUILD"
  
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    # filter {
    #   type    = "BASE_REF"
    #   pattern = "main"
    # }
  }
}