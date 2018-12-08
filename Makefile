# Some defaults
AWS ?= aws
AWS_REGION ?= eu-west-1
AWS_PROFILE ?= default

AWS_CMD := $(AWS) --profile $(AWS_PROFILE) --region $(AWS_REGION)

INSTANCE_NAME ?= default
PARAMETERS := ParameterKey=InstanceName,ParameterValue=$(INSTANCE_NAME)
TAGS ?= Key=Deployment,Value=adhoc-instance Key=DeploymentName,Value=adhoc-instance-$(INSTANCE_NAME)

define stack_template =

validate-$(basename $(notdir $(1))): $(1)
	 $(AWS_CMD) cloudformation validate-template\
		--template-body file://$(1)

create-$(basename $(notdir $(1))): $(1)
	$(AWS_CMD) cloudformation create-stack \
		--stack-name $(basename $(notdir $(1)))-$(INSTANCE_NAME) \
		--tags $(TAGS) \
		--parameters $(PARAMETERS) \
		--template-body file://$(1) \
		--capabilities CAPABILITY_NAMED_IAM

update-$(basename $(notdir $(1))): $(1)
	$(AWS_CMD) cloudformation update-stack \
		--stack-name $(basename $(notdir $(1)))-$(INSTANCE_NAME) \
		--tags $(TAGS) \
		--parameters $(PARAMETERS) \
		--template-body file://$(1) \
		--capabilities CAPABILITY_NAMED_IAM

delete-$(basename $(notdir $(1))): $(1)
	$(AWS_CMD) cloudformation delete-stack \
		--stack-name $(basename $(notdir $(1)))-$(INSTANCE_NAME)

endef

$(foreach template, $(wildcard templates/*.yaml), $(eval $(call stack_template,$(template))))
