import boto3
import os

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb', region_name=os.environ['AWS_REGION'])

# Define the table name
table_name = 'arc-saas-dev-tenant-terraform-details'

# Access environment variables from CodeBuild
environment_variables = {
    'AWS_ACCOUNT_ID': os.environ.get('AWS_ACCOUNT_ID'),
    'EKS_CLUSTER_NAME': os.environ.get('EKS_CLUSTER_NAME'),
    'AUTH_CODE_EXPIRATION': os.environ.get('AUTH_CODE_EXPIRATION'),
    'USERNAME': os.environ.get('USERNAME'),
    'KEY': os.environ.get('KEY'),
    'TENANT_EMAIL': os.environ.get('TENANT_EMAIL'),
    'TENANT': os.environ.get('TENANT'),
    'ACCESS_TOKEN_EXPIRATION': os.environ.get('ACCESS_TOKEN_EXPIRATION'),
    'CB_ROLE': os.environ.get('CB_ROLE'),
    'TENANT_CLIENT_SECRET': os.environ.get('TENANT_CLIENT_SECRET'),
    'KARPENTER_ROLE': os.environ.get('KARPENTER_ROLE'),
    'SECRET': os.environ.get('SECRET'),
    'VPC_CIDR_BLOCK': os.environ.get('VPC_CIDR_BLOCK'),
    'SUBNET_IDS': os.environ.get('SUBNET_IDS'),
    'RDS_POSTGRES_STORAGE': os.environ.get('RDS_POSTGRES_STORAGE'),
    'CONTROL_PLANE_HOST': os.environ.get('CONTROL_PLANE_HOST'),
    'TENANT_CLIENT_ID': os.environ.get('TENANT_CLIENT_ID'),
    'VPC_ID': os.environ.get('VPC_ID'),
    'REFRESH_TOKEN_EXPIRATION': os.environ.get('REFRESH_TOKEN_EXPIRATION'),
    'AWS_REGION': os.environ.get('AWS_REGION'),
    'ENVIRONMENT': os.environ.get('ENVIRONMENT'),
    'TENANT_DATA': os.environ.get('TENANT_DATA'),
    'TENANT_ID': os.environ.get('TENANT_ID'),
    'NAMESPACE': os.environ.get('NAMESPACE'),
    'DOMAIN_NAME': os.environ.get('DOMAIN_NAME')
}

# Get the TENANT_ID or use 'unknown' if not present
tenant_id = environment_variables.get('TENANT_ID', 'unknown')

# Push data to DynamoDB
table = dynamodb.Table(table_name)
for key, value in environment_variables.items():
    if value is not None:  # Only push non-empty values
        response = table.put_item(
            Item={
                'TENANT_ID': tenant_id,
                'variable_name': key,
                'value': value
            }
        )

        print(response)
