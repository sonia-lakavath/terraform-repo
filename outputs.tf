
output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web_instance.public_ip
}

output "web_url" {
  description = "URL of the web server"
  value       = "http://${aws_instance.web_instance.public_ip}"
}
