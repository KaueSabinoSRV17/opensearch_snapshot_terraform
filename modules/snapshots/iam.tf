locals {
  name = "opensearch-snapshots"
}

data "aws_iam_user" "devops" {
  user_name = var.user_name
}

data "aws_opensearch_domain" "opensearch" {
  domain_name = var.domain_name
}

resource "aws_iam_role" "opensearch_snapshots" {
  name               = local.name
  assume_role_policy = file("${path.module}/policies/opensearch_s3_assume_role.json")
}

resource "aws_iam_policy" "opensearch_snapshots" {
  name = local.name
  policy = templatefile("${path.module}/policies/opensearch_s3_policy.json", {
    BUCKET_NAME = var.bucket_name
  })
}

resource "aws_iam_role_policy_attachment" "opensearch_snapshots" {
  role       = aws_iam_role.opensearch_snapshots.name
  policy_arn = aws_iam_policy.opensearch_snapshots.arn
}

resource "aws_iam_user_policy" "inline_opensearch_policy" {
  name = local.name
  user = data.aws_iam_user.devops.user_name

  policy = templatefile("${path.module}/policies/inline_opensearch_policy.json", {
    ACCOUNT_ID             = var.account_id
    ROLE_NAME              = local.name
    OPENSEARCH_DOMAIN_NAME = data.aws_opensearch_domain.opensearch.domain_name
    REGION                 = var.region
  })
}
