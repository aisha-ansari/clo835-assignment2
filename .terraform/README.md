
# Welcome to the README file for CLO835 Assignment 1!

This assignment is done  Asif Raja

## Assignment 1 Title:

## Create Dockerfile, build docker image and deploy docker container on Amazon Linux EC2  


## Table of Contents
- [Using Terraform code to Deploy EC2 instance in public subnet ](#using-terraform-to-deploy-EC2-instance-in-public-subnet)
- [Using GitHub action to create docker images and  push them to Amzon ECR](#using-github-action-for-automation)



## Using Terraform to EC2 instance in public subnet. 

Instructions on using Terraform to deploy EC2 instance.

- Clone the repo in your local machine 
 Use below command 
- git init 
- git clone https://github.com/brtasif/clo835-assignment1.git
- Go to terraform_code/dev/instances/ directory and follow the steps 
- terrafrom init # initialize terrform
- terraform fmt
- terraform validate
- terraform plan 
- terrform apply -auto-approve


## Using GitHub action

Instructions on using GitHub action.
- Work on your application code and mysql code and docker files in developer branch 
- git add .
- git commit -m "commit "
- git push 
- Git action is triggered as follows:
- Docker workflow will trigger on any push or pull_request on master branch 

## Using EC2 instance to host the application and database container

Instruction on using EC3 instance to run docker containers
- ssh to EC2 instance 
- Run the docker run command to build the containers on top of docker images stored in Amazon ECR

.

