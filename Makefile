.PHONY: all

PROJECT?=system-engineer
include vars/system-engineer
export

all: vpc key ami

vpc:
	ansible-playbook -e "stack_name=vpc-${PROJECT_NAME} keyname=${PROJECT_NAME} \
	region=${REGION} vpccidr=${VPCCIDR} pub_sub_1=${PUB_SUB_1} pub_sub_2=${PUB_SUB_2} \
	priv_sub_1=${PRIV_SUB_1} priv_sub_2=${PRIV_SUB_2} state=${STATE}" ansible/vpc.yml

key:
	if [ ! -d "keys/" ]; then \
	      mkdir keys; \
	fi; \
	if [ ! -f "keys/${PROJECT_NAME}.pem" ]; then \
	      echo "Creating keypair. Keep it safe!"; \
	      aws ec2 create-key-pair --key-name ${PROJECT_NAME} --query 'KeyMaterial' --output text > keys/${PROJECT_NAME}.pem; \
	else \
	      echo "There is a key in the directory"; \
	fi;

ami:
	$(eval VPCID=$(shell aws cloudformation --region us-east-1 describe-stacks --stack-name vpc-${PROJECT_NAME} --query 'Stacks[0].Outputs[?OutputKey==`VPC`].OutputValue' --output text))
	$(eval SUBNETID=$(shell aws cloudformation --region us-east-1 describe-stacks --stack-name vpc-${PROJECT_NAME} --query 'Stacks[0].Outputs[?OutputKey==`PrivateSubnet1`].OutputValue' --output text))
	./packer build -var aws_ami=${BASE_AMI} -var version=${VERSION} \
	-var aws_vpc_id=${VPCID} -var aws_subnet_id=${SUBNETID} \
	-var project_name=${PROJECT_NAME} -var ami-name=${AMI-NAME} \
	-var instance_type=${INSTANCE_TYPE} -var app_origin=${APP_ORIGIN} \
	 -var app_user_adm=${APP_USER} -var app_group_adm=${APP_GROUP} aws-ami/ami.json

asg:
	$(eval LC_AMI=$(shell aws ec2 describe-images --filters "Name=tag-key,Values=Name" "Name=tag-value,Values=${PROJECT_NAME}" "Name=tag-key,Values=version" "Name=tag-value,Values=${VERSION}" --query 'sort_by(Images, &CreationDate)[].ImageId' --output text | grep -m5 "ami"))
	ansible-playbook -e "stack_name=asg-${PROJECT_NAME} keyname=${PROJECT_NAME} \
	imageid=${LC_AMI} keyname=${PROJECT_NAME} instancetype=${INSTANCE_TYPE} state=${STATE} \
	vpc_stack=vpc-${PROJECT_NAME} vpccidr=${VPCCIDR} email=${EMAIL}" ansible/asg.yml

destroy: key-destroy asg-destroy vpc-destroy 

key-destroy:
	aws ec2 delete-key-pair --key-name ${PROJECT_NAME}
	rm -rf keys/${PROJECT_NAME}.pem

vpc-destroy:
	$(eval STATE=absent)
	ansible-playbook -e "stack_name=vpc-${PROJECT_NAME} keyname=${PROJECT_NAME} \
	region=${REGION} vpccidr=${VPCCIDR} pub_sub_1=${PUB_SUB_1} pub_sub_2=${PUB_SUB_2} \
	priv_sub_1=${PRIV_SUB_1} priv_sub_2=${PRIV_SUB_2} state=${STATE}" ansible/vpc.yml

asg-destroy:
	$(eval STATE=absent)
	ansible-playbook -e "stack_name=asg-${PROJECT_NAME} keyname=${PROJECT_NAME} \
	imageid=${LC_AMI} keyname=${PROJECT_NAME} instancetype=${INSTANCE_TYPE} state=${STATE} \
	vpc_stack=vpc-${PROJECT_NAME} vpccidr=${VPCCIDR} email=${EMAIL}" ansible/asg.yml
