# Creating public route table

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

    route {
        cidr_block = var.DEFAULT_VPC_CIDR
        vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "robot-${var.ENV}-public-rt"
    }
}

# public route table association

resource "aws_route_table_association" "public-rt-association" {
  count          = length(aws_subnet.public-subnet.*.id)
  subnet_id      = element(aws_subnet.public-subnet.*.id, count.index)
  route_table_id = aws_route_table.public-rt.id
}

# Creating private route table

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

    route {
        cidr_block = var.DEFAULT_VPC_CIDR
        vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
    }


    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.ngw.id
    }

    tags = {
        Name = "robot-${var.ENV}-private-rt"
    } 
}

# private route table association

resource "aws_route_table_association" "private-rt-association" {
  count          = length(aws_subnet.private-subnet.*.id)
  subnet_id      = element(aws_subnet.private-subnet.*.id, count.index)
  route_table_id = aws_route_table.private-rt.id
}



resource "aws_route" "peer-route" {
  route_table_id            = var.DEFAULT_RT_ID
  destination_cidr_block    = var.VPC_CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

