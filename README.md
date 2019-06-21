CloudFormation templates for launching ad-hoc spot instances with (or without) persistent data volumes.

## Usage

The templates are built on top of [sjakthol/aws-account-infra](https://github.com/sjakthol/aws-account-infra)
templates so you will need to deploy a VPC and subnets from there to use these
templates as is.

### Instance Without Persistent Data Volume
```bash
# Create instance with defaults (m5.large spot with Ubuntu 18.04)
make deploy-adhoc-instance

# Create instance with custom settings
make deploy-adhoc-instance AMI_NAME=UbuntuDL INSTANCE_TYPE=m4.large INSTANCE_MARKET=ondemand

# Delete instance
make delete-adhoc-instance
```

### Instance with Persistent Data Volume
The following commands will setup an instance that has a persistent EBS volume
mounted to /data (not deleted when instance is terminated):

```bash

# Create data volume and instance with defaults (5GB persistent volume, m5.large
# spot with Ubuntu 18.04)
make deploy-adhoc-instance-data
make deploy-adhoc-instance

# Create instance with custom settings (100G volume, m4.large ondemand with Ubuntu
# Deep Learning AMI)
make deploy-adhoc-instance-data VOLUME_SIZE=100
make deploy-adhoc-instance AMI_NAME=UbuntuDL INSTANCE_TYPE=m4.large INSTANCE_MARKET=ondemand

# Terminate instance but keep data volume around
make delete-adhoc-instance

# Start new instance using the old data volume
make deploy-adhoc-instance

# Tear down the instance + data
make delete-adhoc-instance
make delete-adhoc-instance-data
```

The data volume is mounted to /data on the instance.
