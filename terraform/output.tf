output "public_ip" {
  value       = aws_instance.web_app.public_ip
  description = "The public IP address of the EC2 instance."
}

output "app_url" {
  value       = "http://${aws_instance.web_app.public_ip}:5000"
  description = "The URL to access your deployed web application."
}

