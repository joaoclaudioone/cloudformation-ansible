.PHONY: all

PROJECT_NAME?=systems-engineer-interview
VERSION?=
VPCID=vpc-04c0e211aef7c4176
BASE_AMI=ami-0080e4c5bc078760e
SUBNETID=subnet-0c270a57ab5e9f723

ami:
	./packer build -var aws_ami=${BASE_AMI} -var version=${VERSION} -var aws_vpc_id=${VPCID} -var aws_subnet_id=${SUBNETID} ami.json
