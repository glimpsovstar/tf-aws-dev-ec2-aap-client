variable "aws_region" {
  type =  string
  default = "ap-southeast-2"
}

variable "ami_id" {
  type        = string
#  default     = "ami-0808460885ff81045" #RHEL8
  default     = "ami-0d699116d22d2cb59" #RHEL9 - 2025-05-28
  description = "The id of the machine image (AMI) to use for the server."

}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "aws_key_pair_name" {
    type = string
    default = "djoo-demo-ec2-keypair"
}

variable "ec2_tags" {
  description = "Tags for EC2 instance"
  type        = map(string)
  default     = {
    Terraform   = "true"
    Environment = "Dev"
    Owner = "djoo"
    Name = "tf-aws-dev-ec2-RHEL"
    Test_Tag = "This is a demo for SCG"
  }
}


