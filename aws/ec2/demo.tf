provider "aws" {
  region = "us-west-1"
}

resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_network_acl" "demo_nacl" {
  vpc_id = aws_vpc.demo_vpc.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "demo_nacl"
  }
}

resource "aws_subnet" "demo_subnet" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  network_acl_id          = aws_network_acl.demo_nacl.id
}

resource "aws_security_group" "demo_sg" {
  vpc_id = aws_vpc.demo_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo_sg"
  }
}

resource "aws_instance" "demo_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Update with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.demo_subnet.id

  vpc_security_group_ids = [
    aws_security_group.demo_sg.id,
  ]

  tags = {
    Name = "demo_instance"
  }
}
