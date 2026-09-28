provider "aws" {
  region = "us-east-1"
}

# Create Security Group for Web Traffic
resource "aws_security_group" "web_sg" {
  name        = "react_ec2_security_group"
  description = "Allow inbound HTTP and SSH traffic"

  ingress {
    description = "HTTP Traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Narrow this down to your IP for actual production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Deploy EC2 Instance and Bootstrap App
resource "aws_instance" "react_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Bootstrapping shell script to configure Ubuntu, NGINX, and Node.js
  user_data = <<-EOF
              #!/bin/bash
              # Redirect stdout and stderr to a log file for runtime debugging
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

              echo "=== Starting Bootstrap Pipeline ==="

              # 1. Update system packages and install dependencies
              sudo apt-get update -y
              sudo apt-get install -y nginx git

              # 2. Install Node.js v20 LTS
              curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
              sudo apt-get install -y nodejs

              # 3. Clone repository
              cd /home/ubuntu
              rm -rf sample-app # Clean up any existing dirty directories
              git clone https://github.com/KnightPrime/react-app-ec2 sample-app
              cd sample-app

              # 4. Install dependencies and compile build
              echo "=== Executing npm build steps ==="
              npm install
              npm run build

              # 5. Deploy application files to NGINX web root
              sudo rm -rf /var/www/html/*
              sudo cp -r build/* /var/www/html/

              # 6. Apply strict file permissions to ensure NGINX access
              sudo chown -R www-data:www-data /var/www/html
              sudo chmod -R 755 /var/www/html

              # 7. Configure NGINX to route all requests back to index.html (Required for SPA routing)
              cat << 'NGINX_CONF' | sudo tee /etc/nginx/sites-available/default
              server {
                  listen 80 default_server;
                  listen [::]:80 default_server;

                  root /var/www/html;
                  index index.html;

                  server_name _;

                  location / {
                      try_files $uri $uri/ /index.html;
                  }
              }
              NGINX_CONF

              # 8. Restart NGINX to apply configuration changes
              sudo systemctl restart nginx
              echo "=== Bootstrap Pipeline Completed ==="
              EOF

  tags = {
    Name = "React-Web-Server"
  }
}

