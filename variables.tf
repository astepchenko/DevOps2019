variable "region" {
  default = "us-east-2"
}

variable "public_key_path" {
  default = "/home/user/.aws/aws.pem"
}

variable "key_name" {
  default = "aws"
}

variable "amis" {
  default = {
    us-east-2 = "ami-0c55b159cbfafe1f0"
  }
}