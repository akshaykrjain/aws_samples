variable "key_pair_name" {
  type    = string
  default = "akshay"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "default" {
  default = true
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_tls"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from My IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_my_ip"
  }
}

# Request a one-time spot instance
resource "aws_spot_instance_request" "cheap_worker" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t4g.micro"
  spot_type              = "one-time"
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "SpotInstance"
  }
}