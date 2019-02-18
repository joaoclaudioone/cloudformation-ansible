.PHONY: all

PROJECT_NAME=systems-engineer-interview


vpc:
	ansible-playbook ansible/vpc.yml

asg:
	ansible-playbook ansible/asg.yml

key:
	aws ec2 create-key-pair --key-name ${PROJECT_NAME} --query 'KeyMaterial' --output text > keys/${PROJECT_NAME}.pem

delete-key:
	aws ec2 describe-key-pairs --key-name ${PROJECT_NAME}
