provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region                  = "us-east-2"
}

resource "aws_instance" "task11_lb" {
  ami           = "ami-0cd3dfa4e37921605"
  instance_type = "t2.micro"
}
