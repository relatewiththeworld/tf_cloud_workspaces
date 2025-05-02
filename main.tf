terraform { 
  cloud { 
    
    organization = "DevOps_Training_Org" 

    workspaces { 
      tags = ["dotnet"] 
    } 
  } 
}

provider "aws" {
  # Configuration options
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

#Create VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

#Create Internet Gateway and attach it to VPC
resource aws_internet_gateway "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "tf_igw"
  }
}

#Create subnet
resource "aws_subnet" "tf_subnet" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_name
  }
}

#Create Route Table and attach Internet Gateway
resource "aws_route_table" "tf_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }

  tags = {
    Name = var.rt_name
  }
}

#Create Route Table association with subnet
resource "aws_route_table_association" "tf_rt_assoc" {
  subnet_id = aws_subnet.tf_subnet.id
  route_table_id = aws_route_table.tf_rt.id
}

#Create a Network Security Group
resource "aws_security_group" "tf_sg" {
  name = "tf_sg"
  description = "Security Group for Terraform"
  vpc_id = aws_vpc.tf_vpc.id
 
  ingress {
    description = "Allow SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    description = "Allow HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf_sg"
  }
}

#Create a EC2 Instance
resource "aws_instance" "tf_instance" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.tf_subnet.id
  vpc_security_group_ids = [aws_security_group.tf_sg.id]
  key_name = var.key_name
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash  
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2
              echo "<h1>Welcome to our Terraform Web Server </h1>" > /var/www/html/index.html
              EOF

tags = {
    Name = var.instance_name
    }
}