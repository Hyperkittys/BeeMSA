output "ecs_task_role_arn" {
    value = aws_iam_role.ecs_task_role.arn
}
output "ecs_task_execution_role_arn" {
    value = aws_iam_role.ecs_task_execution_role.arn
}
output "codepipeline_role_arn" {
    value = aws_iam_role.codepipeline_role.arn
}
output "manageKeywords_codebuild_role_arn" {
    value = aws_iam_role.codebuild_role.arn
}
output "issue_codebuild_role_arn" {
    value = aws_iam_role.codebuild_role.arn
}
output "keywordnews_codebuild_role_arn" {
    value = aws_iam_role.codebuild_role.arn
}