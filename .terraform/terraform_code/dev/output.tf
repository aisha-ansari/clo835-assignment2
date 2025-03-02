
# Output the Elastic IP (EIP)
output "eip" {
  value = aws_eip.static_eip.public_ip
}

# Output the EC2 Instance ID
output "instance_id" {
  value = aws_instance.my_amazon.id
}

# Output the Webapp ECR Repository URI
output "webapp_ecr_uri" {
  value = aws_ecr_repository.webapp.repository_url
}

# Output the MySQL ECR Repository URI
output "mysql_ecr_uri" {
  value = aws_ecr_repository.mysql.repository_url
}
