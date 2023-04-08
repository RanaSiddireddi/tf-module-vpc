#this is to create VPC

resource "aws_vpc" "main" {
  cidr_block = var.VPC_CIDR
}

