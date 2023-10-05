output "name" {
  value = aws_iam_role.opensearch_snapshots.arn
}

output "bucket_region" {
  value = aws_s3_bucket.snapshots.region
}
