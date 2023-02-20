variable "key_pair_name" {
  type    = string
  default = "NEP-MAC"
}

data "cloudinit_config" "server_config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content      = file("${path.module}/server.yaml")
  }
}

##UBUNTU AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

## USE BELOW FOR Amazon Linux 2 AMI

data "aws_ami" "amzn2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2*arm*64-gp2"]
  }
  owners = ["amazon"]
}

data "aws_vpc" "default" {
  default = true
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "web_server" {
  name        = "allow_tls"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web_server"
  }
}

resource "aws_security_group_rule" "ssh_allow" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = aws_security_group.web_server.id
}

resource "aws_security_group_rule" "http_allow" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.web_server.id
}


resource "aws_iam_role" "ec2_instance" {
  name               = "ec2_instance_role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "attach_ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2_instance.name
}

resource "aws_iam_role_policy_attachment" "attach_admin" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.ec2_instance.name
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_instance.name
}


resource "aws_instance" "web" {
  ami                         = data.aws_ami.amzn2.id
  instance_type               = "t4g.medium"
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [aws_security_group.web_server.id]
  user_data                   = data.cloudinit_config.server_config.rendered
  user_data_replace_on_change = true
  tags = {
    Name = "WebServer-Ubuntu"
  }
}

output "WEB_ADDRESS" {
  value = "http://${aws_instance.web.public_ip}"
}


output "ssh" {

  value = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.web.public_ip}"

}
