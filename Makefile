.PHONY: all

PROJECT_NAME=systems-engineer-interview
VERSION?=
AMI_NAME=ami-deploy
LC_AMI=$(shell aws ec2 describe-images --filters "Name=tag-key,Values=Name" "Name=tag-value,Values=${AMI_NAME}" --query 'sort_by(Images, &CreationDate)[].ImageId' --output text | grep -m5 "ami")

vpc:
	ansible-playbook ansible/vpc.yml

asg:
	ansible-playbook ansible/asg.yml -e "keyname=${PROJECT_NAME} imageid=${LC_AMI}"

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

delete-key:
	aws ec2 delete-key-pair --key-name ${PROJECT_NAME};
	rm -rf keys/${PROJECT_NAME}.pem

ami:
	"$(MAKE)" -C ami/ ami -e PROJECT_NAME=${PROJECT_NAME} -e VERSION=${VERSION}
