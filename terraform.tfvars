account_id = "111928192316"
codebuild_params = {
      "NAME" = "codebuild-demo-terraform"
      "GIT_REPO" = "https://github.com/jj-ops-gif/cd12355-microservices-aws-kubernetes-project-starter.git"
      "IMAGE" = "aws/codebuild/standard:4.0"
      "TYPE" = "LINUX_CONTAINER"
      "COMPUTE_TYPE" = "BUILD_GENERAL1_SMALL"
      "CRED_TYPE" = "CODEBUILD"
  } 

environment_variables = {
      "AWS_DEFAULT_REGION" = "us-east-1"
      "AWS_ACCOUNT_ID" = "111928192316"
      "IMAGE_REPO_NAME" = "coworking"
      "IMAGE_TAG" = "latest"
  }