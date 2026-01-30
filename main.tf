# created the S3 and DynamoDB

terraform {
  backend "s3" {
    bucket         = "kistipati-terraform-state"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}
# 1. Define the Provider (AWS)
provider "aws" {
  region = var.region
}

# 2. Create the VPC (the gated community )
resource "aws_vpc" "main_vpc"{
cidr_block = "10.0.0.0/16"

tags = {
 Name = "Resume-project-VPC"
}
}

# 3. create a public subnet (the front gate)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet"
  }
}

#4 create an Internet Gateway  (the connection to the world )

resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main_vpc.id
 tags = {
  Name = "Main-IGW"
}
}

# 5. Create a Security Group (The Firewall)
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  vpc_id      = aws_vpc.main_vpc.id

  # Allow SSH (Port 22) so you can connect to it
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # In real life, you'd put your own IP here
  }

  # Allow HTTP (Port 80) for web traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic (so the server can update itself)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 6. Create the EC2 Instance (The Server)
resource "aws_instance" "web_server" {
  ami           = "ami-0c7217cdde317cfec" # This is a standard Ubuntu ID for us-east-1
  instance_type = var.instance_type              # Free Tier eligible
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = var.server_name
  }
}
