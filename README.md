CloudFormation templates for launching ad-hoc spot instances with persistent data volumes.

## Usage

The templates are built on top of [sjakthol/aws-account-infra](https://github.com/sjakthol/aws-account-infra)
templates so you will need to deploy a VPC and subnets from there to use these
templates as is.

```bash
# Create data volume + instance
make create-adhoc-instance-data
make create-adhoc-instance

# Terminate instance but keep data volume around
make delete-adhoc-instance

# Start new instance using the old data volume
make create-adhoc-instance

# Tear down the instance + data
make delete-adhoc-instance
make delete-adhoc-instance-data
```

The data volume is mounted to /data on the instance.
