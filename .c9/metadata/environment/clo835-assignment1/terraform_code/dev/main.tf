{"filter":false,"title":"main.tf","tooltip":"/clo835-assignment1/terraform_code/dev/main.tf","undoManager":{"mark":4,"position":4,"stack":[[{"start":{"row":54,"column":0},"end":{"row":54,"column":13},"action":"insert","lines":["3.214.109.189"],"id":42}],[{"start":{"row":59,"column":2},"end":{"row":59,"column":60},"action":"remove","lines":["key_name                    = aws_key_pair.my_key.key_name"],"id":43},{"start":{"row":59,"column":2},"end":{"row":60,"column":0},"action":"insert","lines":["key_name = \"assignment-dev\"",""]}],[{"start":{"row":59,"column":29},"end":{"row":60,"column":0},"action":"remove","lines":["",""],"id":44}],[{"start":{"row":54,"column":12},"end":{"row":54,"column":13},"action":"remove","lines":["9"],"id":45},{"start":{"row":54,"column":11},"end":{"row":54,"column":12},"action":"remove","lines":["8"]},{"start":{"row":54,"column":10},"end":{"row":54,"column":11},"action":"remove","lines":["1"]},{"start":{"row":54,"column":9},"end":{"row":54,"column":10},"action":"remove","lines":["."]},{"start":{"row":54,"column":8},"end":{"row":54,"column":9},"action":"remove","lines":["9"]},{"start":{"row":54,"column":7},"end":{"row":54,"column":8},"action":"remove","lines":["0"]},{"start":{"row":54,"column":6},"end":{"row":54,"column":7},"action":"remove","lines":["1"]},{"start":{"row":54,"column":5},"end":{"row":54,"column":6},"action":"remove","lines":["."]},{"start":{"row":54,"column":4},"end":{"row":54,"column":5},"action":"remove","lines":["4"]},{"start":{"row":54,"column":3},"end":{"row":54,"column":4},"action":"remove","lines":["1"]},{"start":{"row":54,"column":2},"end":{"row":54,"column":3},"action":"remove","lines":["2"]},{"start":{"row":54,"column":1},"end":{"row":54,"column":2},"action":"remove","lines":["."]}],[{"start":{"row":54,"column":0},"end":{"row":54,"column":1},"action":"remove","lines":["3"],"id":46}],[{"start":{"row":0,"column":0},"end":{"row":158,"column":0},"action":"remove","lines":["","#  Define the provider","provider \"aws\" {","  region = \"us-east-1\"","}","","# Data source for Amazon Linux AMI","data \"aws_ami\" \"latest_amazon_linux\" {","  owners      = [\"amazon\"]","  most_recent = true","  filter {","    name   = \"name\"","    values = [\"amzn2-ami-hvm-*-x86_64-gp2\"]","  }","}","","# Data source for availability zones in us-east-1","data \"aws_availability_zones\" \"available\" {","  state = \"available\"","}","","# Data source to retrieve the default VPC id","data \"aws_vpc\" \"default\" {","  default = true","}","","# Define tags locally and naming prefix","locals {","  default_tags = {","    \"env\" = var.env","  }","  prefix = var.prefix","  name_prefix = \"${local.prefix}-${var.env}\"","}","","","# ECR Repository for mysql","resource \"aws_ecr_repository\" \"mysql\" {","  name = \"my-mysql-repo\"","  force_delete = true","  tags = merge(local.default_tags, { \"Name\" = \"my-mysql-repo\" })","}","","# ECR Repository for webapp","resource \"aws_ecr_repository\" \"webapp\" {","  name = \"my-webapp-repo\"","  force_delete = true","  tags = merge(local.default_tags, { \"Name\" = \"my-webapp-repo\" })","}","","# Retrieve IAM Instance Profile","data \"aws_iam_instance_profile\" \"ec2_profile\" {","  name = \"LabInstanceProfile\"","}","","# EC2 Instance","resource \"aws_instance\" \"my_amazon\" {","  ami                         = data.aws_ami.latest_amazon_linux.id","  instance_type               = \"t2.micro\"  # or use a variable if needed","  key_name = \"assignment-dev\"","  vpc_security_group_ids      = [aws_security_group.my_sg.id]","  associate_public_ip_address = false","","  iam_instance_profile = data.aws_iam_instance_profile.ec2_profile.name","","  user_data = <<-EOF","    #!/bin/bash","    sudo yum update -y","    sudo amazon-linux-extras install docker -y","    sudo systemctl start docker","    sudo systemctl enable docker","    sudo usermod -a -G docker ec2-user","  EOF","","  lifecycle {","    create_before_destroy = true","  }","","  tags = merge(local.default_tags, { \"Name\" = \"webapp-instance\" })","}","","# Key Pair","resource \"aws_key_pair\" \"my_key\" {","  key_name   = \"assignment-dev\"","  public_key = file(\"~/.ssh/assignment-dev.pub\")","}","","# Security Group","resource \"aws_security_group\" \"my_sg\" {","  name        = \"allow_ssh\"","  description = \"Allow SSH inbound traffic\"","  vpc_id      = data.aws_vpc.default.id","  ","  ingress {","    description = \"SSH from everywhere\"","    from_port   = 22","    to_port     = 22","    protocol    = \"tcp\"","    cidr_blocks = [\"0.0.0.0/0\"]","  }","","  ingress {","    description = \"HTTP\"","    from_port   = 80","    to_port     = 80","    protocol    = \"tcp\"","    cidr_blocks = [\"0.0.0.0/0\"]","  }","  ","  ingress {","    description = \"HTTP on port 8080\"","    from_port   = 8080","    to_port     = 8080","    protocol    = \"tcp\"","    cidr_blocks = [\"0.0.0.0/0\"]","  }","  ","  ingress {","    description = \"HTTP on port 8081\"","    from_port   = 8081","    to_port     = 8081","    protocol    = \"tcp\"","    cidr_blocks = [\"0.0.0.0/0\"]","  }","","  ingress {","    description = \"HTTP on port 8082\"","    from_port   = 8082","    to_port     = 8082","    protocol    = \"tcp\"","    cidr_blocks = [\"0.0.0.0/0\"]","  }","  ","  ","  ingress {","    description = \"HTTP on port 8083\"","    from_port   = 8083","    to_port     = 8083","    protocol    = \"tcp\"","    cidr_blocks = [\"0.0.0.0/0\"]","  }","  ","","  egress {","    from_port   = 0","    to_port     = 0","    protocol    = \"-1\"","    cidr_blocks = [\"0.0.0.0/0\"]","  }","","  tags = merge(local.default_tags, { \"Name\" = \"${local.name_prefix}-sg\" })","}","","# Elastic IP","resource \"aws_eip\" \"static_eip\" {","  instance = aws_instance.my_amazon.id","  tags = merge(local.default_tags, { \"Name\" = \"${local.name_prefix}-eip\" })","}",""],"id":47}]]},"ace":{"folds":[],"scrolltop":1968,"scrollleft":0,"selection":{"start":{"row":158,"column":0},"end":{"row":158,"column":0},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":{"row":139,"state":"start","mode":"ace/mode/terraform"}},"timestamp":1740887949424,"hash":"7883a8d70226833ebc226a4d61d2e0ba1f86066e"}