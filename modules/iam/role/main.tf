locals {
  # Build the list of principals for the trust policy
  ecs_principal = var.assume_role_principals.ecs ? ["ecs-tasks.amazonaws.com"] : []

  service_principals = local.ecs_principal
  aws_principals     = var.assume_role_principals.aws_principals
}

data "aws_iam_policy_document" "assume_role" {
  dynamic "statement" {
    for_each = length(local.service_principals) > 0 ? [1] : []
    content {
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "Service"
        identifiers = local.service_principals
      }
    }
  }

  dynamic "statement" {
    for_each = length(local.aws_principals) > 0 ? [1] : []
    content {
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "AWS"
        identifiers = local.aws_principals
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count = length(var.policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = var.policy_arns[count.index]
}
