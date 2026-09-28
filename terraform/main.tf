provider "aws" {
  region = var.aws_region
}

# Create a Default VPC
resource "aws_default_vpc" "default" {}

# Create Security Group allowing HTTP access to App Port (5000) and SSH (22)
resource "aws_security_group" "web_sg" {
  name        = "app-web-security-group"
  description = "Allow inbound web traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Lookup latest Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# Launch the EC2 Instance
resource "aws_instance" "web_app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Startup configurations to download node, clone project, build and host
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              
              # Install Node.js v20 LTS
              curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
              sudo apt-get install -y nodejs git

              # Install PM2 to keep the Node application alive in the background
              sudo npm install -g pm2

              # Create application directory
              mkdir -p /home/ubuntu/app
              cd /home/ubuntu/app

              # NOTE: Replace this with your actual Git Repository URL
              # For demonstration, we simulate local population or direct git clone
              # git clone <YOUR_GITHUB_REPO_URL> .

              # Alternative: Writing files directly via user_data if testing standalone
              # (For best practice, replace this block with your git clone step!)
              
              # Build and run the app
              # cd frontend && npm install && npm run build
              # cd ../backend && npm install
              # pm2 start server.js --name "node-react-app"
              EOF

  tags = {
    Name = "NodeReactWebServer"
  }
}

