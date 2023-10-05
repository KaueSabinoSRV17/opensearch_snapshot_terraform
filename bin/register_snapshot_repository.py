#!/usr/bin/python3

import boto3
import requests
from requests_aws4auth import AWS4Auth

def ask(message):
    return input(message).strip()

host = ask("Type your Opensearch host: ")
region = ask("Type your AWS Region: ")
first_repository_name = ask("Type the name of your first snapshot repository: ")
bucket_name = ask("Type the name of the snapshot bucket: ")
role_arn = ask("Paste the arn of the role that you have just created: ")

service = 'es'
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)

path = f'_snapshot/{first_repository_name}' # the OpenSearch API endpoint
url = host + path

payload = {
  "type": "s3",
  "settings": {
    "bucket": bucket_name,
    "region": region,
    "role_arn": role_arn,
    "server_side_encryption": "true"
  }
}

headers = {"Content-Type": "application/json"}

r = requests.put(url, auth=awsauth, json=payload, headers=headers)

print(r.text)
