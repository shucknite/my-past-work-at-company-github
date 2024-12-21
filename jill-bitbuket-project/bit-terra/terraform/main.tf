provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

# resource "aws_instance" "linux" {
#   ami           = "ami-012967cc5a8c9f891" # Replace with the desired AMI ID
#   instance_type = "t2.micro"              # Choose an instance type
#   key_name      = "virginia"  
#   count = 1       # Add your SSH key name
#   tags = {
#     Name = "ansible_instance_linux"
#     Env = "dev"
#   }
# }


resource "aws_instance" "ubuntu" {
  ami           = "ami-0c7217cdde317cfec" # Replace with the desired AMI ID
  instance_type = "t2.micro"              # Choose an instance type
  key_name      = "virginia"  
  count = 2      # Add your SSH key name
  tags = {
    Name = "ansible_instance_linux"
    Env = "dev"
  }
}

# output "instance_id" {
#   value = aws_instance.example.id
# }

# output "public_ip" {
#   value = aws_instance.example.public_ip
# }
