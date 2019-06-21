# Some defaults
AWS ?= aws
AWS_REGION ?= eu-west-1
AWS_PROFILE ?= default

AWS_CMD := $(AWS) --profile $(AWS_PROFILE) --region $(AWS_REGION)

AMI_NAME ?= Ubuntu1804
ATTACH_VOLUME ?= false
INSTANCE_NAME ?= default
INSTANCE_TYPE ?= m5.large
INSTANCE_MARKET ?= spot
VOLUME_SIZE ?= 5
PARAMETERS := \
	AMIName=$(AMI_NAME) \
	AttachVolume=$(ATTACH_VOLUME) \
	InstanceName=$(INSTANCE_NAME) \
	InstanceType=$(INSTANCE_TYPE) \
	InstanceMarket=$(INSTANCE_MARKET) \
	VolumeSize=$(VOLUME_SIZE)

TAGS ?= Deployment=adhoc-instance DeploymentName=adhoc-instance-$(INSTANCE_NAME)

define stack_template =

deploy-$(basename $(notdir $(1))): $(1)
	$(AWS_CMD) cloudformation deploy \
		--stack-name $(basename $(notdir $(1)))-$(INSTANCE_NAME) \
		--capabilities CAPABILITY_NAMED_IAM \
		--no-fail-on-empty-changeset \
		--parameter-overrides $(PARAMETERS) \
		--tags $(TAGS) \
		--template-file $(1)

delete-$(basename $(notdir $(1))): $(1)
	$(AWS_CMD) cloudformation delete-stack \
		--stack-name $(basename $(notdir $(1)))-$(INSTANCE_NAME)

endef

$(foreach template, $(wildcard templates/*.yaml), $(eval $(call stack_template,$(template))))
