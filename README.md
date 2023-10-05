# Opensearch Snapshot Resources

This is all the IAM Policies and other resources needed to resgister your very first Snapshot repository in you 
AWS OpenSearch Cluster.

## Policies and Roles

The following Roles and policies are needed:

### S3 Assume Role Policy

We need to create a Role, that will be assumed by the OpenSearchService.
This is the role trust policy that will be assumed by the OpenSearchService, in your behalf:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "",
    "Effect": "Allow",
    "Principal": {
      "Service": "opensearchservice.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }]
}
```

### S3 Policy

This is the policy attatched to OpenSearch Role:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${BUCKET_NAME}"
      ]
    },
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${BUCKET_NAME}/*"
      ]
    }
  ]
}
```

### Inline User Policy

At last, it will be needed to pass to your AWS user the follwing inline policy, that will ensure you
pass the created role to the OpenSearch Cluster when it tries to create the snapshot:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": "arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}"
    },
    {
      "Effect": "Allow",
      "Action": "es:ESHttpPut",
      "Resource": "arn:aws:es:${REGION}:${ACCOUNT_ID}:domain/${OPENSEARCH_DOMAIN_NAME}/*"
    }
  ]
}
```

## Creating the first snapshot repository with the python script

Creating the snapshot repository requires a HTTP request to made to the Cluster REST API Domain. 
Not only that, but it needs to be with the AWS IAM User that you have added the Inline Policy above.

Before everything, ensure you have your AWS CLI configured with:

```bash
aws configure
```

and that you have Python and Pip installed. You will need to run the following to have the needed dependencies:

```bash
pip install requests boto3 requests_aws4auth
```

To create the first repository, we need to run the python script at `./bin/register_snapshot_repository.py`. It
will make the needed HTTP request authenticated as the same AWS IAM User as your AWS CLI.
