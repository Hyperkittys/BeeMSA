resource "aws_codepipeline" "beemsa_codepipeline" {
    name     = var.beemsa_codepipeline_name
    role_arn = var.codepipeline_role_arn

    artifact_store {
        location = var.codepipeline_bucket_name
        type     = var.codepipeline_artifact_store_type
    }

    stage {
        name = "Source"
        action {
            name     = var.source_stage_codecommit_name
            category = "Source"
            owner    = "AWS"
            provider = "CodeCommit"
            version  = "1"

            output_artifacts = ["${var.source_stage_output_artifacts}"]

            configuration = {
                RepositoryName       = var.codecommit_repository_name
                BranchName           = var.codecommit_branch_name
                PollForSourceChanges = true
                OutputArtifactFormat = "CODE_ZIP"
            }
        }
    }

    stage {
        name = "Build"
        dynamic "action" {
            for_each = var.build_stage_actions
            content {
                name = action.value.name
                category = "Build"
                owner = "AWS"
                provider = "CodeBuild"
                version  = "1"

                input_artifacts = ["${var.source_stage_output_artifacts}"]
                output_artifacts = action.value.output_artifacts

                configuration = {
                    ProjectName = action.value.codebuild_project_name
                }
            }
        }
    }

    stage {
        name = "Deploy"
        dynamic "action" {
            for_each = var.deploy_stage_actions
            content {
                name     = action.value.name
                category = "Deploy"
                owner    = "AWS"
                provider = "ECS"
                version  = "1"

                input_artifacts = action.value.input_artifacts

                configuration = {
                    ClusterName = var.ecs_cluster_name
                    ServiceName = action.value.service_name
                    FileName = var.depoly_stage_file_name
                }
            }
        }
    }
}