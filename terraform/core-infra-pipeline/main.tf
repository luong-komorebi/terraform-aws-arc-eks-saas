#########################################################################
## default
#########################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.4.0"
    }
  }

  backend "s3" {}
}



provider "aws" {
  region = var.region
}

#######################################################################################
## CodePipeline Role
#######################################################################################
resource "aws_iam_role" "codepipeline_role" {
  name = "TerraformCodePipelineRole-${var.namespace}-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "admin_fullaccess" {

  role = aws_iam_role.codepipeline_role.name

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

############################################################################################
## Codepipeline
############################################################################################
resource "aws_codepipeline" "deployment_pipeline" {
  depends_on = [aws_codebuild_project.initial_bootstrap,
    aws_codebuild_project.rds_module_build_step_codebuild_project,
  aws_codebuild_project.networking_module_build_step_codebuild_project]

  name     = "${var.namespace}-${var.environment}-terraform-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.artifact_location
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {

        ConnectionArn    = data.aws_codestarconnections_connection.existing_github_connection.arn
        FullRepositoryId = var.github_FullRepositoryId
        BranchName       = var.github_BranchName

      }
    }
  }
}