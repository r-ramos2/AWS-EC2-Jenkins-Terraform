# Security group allowing traffic for SSH and Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "Jenkins-Security-Group"
  description = "Allow traffic for SSH and Jenkins"

  # SSH Access
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]  # Replace with your actual IP address
    description      = "Allow SSH access"
  }

  # Jenkins Access (public access, adjust as needed)
  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  # Ideally, limit this to trusted IPs or ranges
    description      = "Allow Jenkins access"
  }

  # Allow all outbound traffic (egress)
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-SG"
  }
}

# EC2 instance running Jenkins
resource "aws_instance" "jenkins_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  user_data              = templatefile("${path.module}/JENKINS-TF/install_jenkins.sh", {})

  tags = {
    Name = "Jenkins-Instance"
  }

  root_block_device {
    volume_size = 30  # Set appropriate size (<=30 GB for free-tier)
  }
}