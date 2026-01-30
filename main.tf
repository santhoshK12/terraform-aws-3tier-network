# Standard Provider Block
provider "aws" {
  region = var.region
}

# 1. Call the VPC Module
# This looks into the sub-folder and runs the code there first
module "my_vpc" {
  source = "./modules/vpc"
}

# 2. Create the EC2 Instance
resource "aws_instance" "web_server" {
  ami           = "ami-0c7217cdde317cfec" # Ensure this is correct for us-east-1
  instance_type = var.instance_type
  
  # Crucial: This grabs the ID created inside the module
  subnet_id     = module.my_vpc.subnet_id 

  tags = {
    Name = var.server_name
  }
}
