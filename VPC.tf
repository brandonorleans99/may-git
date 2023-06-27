resource "aws_vpc" "cloudrock-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "cloudrock-vpc"
  }
}

resource "aws_subnet" "prod-pub-sub1" {
  vpc_id     = aws_vpc.cloudrock-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-pub-sub1"
  }
}

resource "aws_subnet" "prod-pub-sub2" {
  vpc_id     = aws_vpc.cloudrock-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "prod-pub-sub2"
  }
}

resource "aws_subnet" "prod-priv-sub1" {
  vpc_id     = aws_vpc.cloudrock-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "prod-priv-sub1"
  }
}

resource "aws_subnet" "prod-priv-sub2" {
  vpc_id     = aws_vpc.cloudrock-vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "prod-priv-sub2"
  }
}

resource "aws_route_table" "prod-pub-route-table" {
  vpc_id = aws_vpc.cloudrock-vpc.id

  tags = {
    Name = "prod-pub-route-table"
  }
}

resource "aws_route_table" "prod-priv-route-table" {
  vpc_id = aws_vpc.cloudrock-vpc.id

  tags = {
    Name = "prod-priv-route-table"
  }
}

resource "aws_route_table_association" "prod-pub-route-table-1" {
  subnet_id      = "${aws_subnet.prod-pub-sub1.id}"
  route_table_id = "${aws_route_table.prod-pub-route-table.id}"
}

resource "aws_route_table_association" "prod-pub-route-table-2" {
  subnet_id      = "${aws_subnet.prod-pub-sub2.id}"
  route_table_id = "${aws_route_table.prod-pub-route-table.id}"
}

resource "aws_route_table_association" "prod-priv-route-table-1" {
  subnet_id      = "${aws_subnet.prod-priv-sub1.id}"
  route_table_id = "${aws_route_table.prod-priv-route-table.id}"
}

resource "aws_route_table_association" "prod-priv-route-table-2" {
  subnet_id      = "${aws_subnet.prod-priv-sub2.id}"
  route_table_id = "${aws_route_table.prod-priv-route-table.id}"
}

resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.cloudrock-vpc.id

  tags = {
    Name = "prod-igw"
  }
}

resource "aws_route" "prod-igw" {
  route_table_id            = aws_route_table.prod-pub-route-table.id
  gateway_id                = aws_internet_gateway.prod-igw.id
  destination_cidr_block    = "0.0.0.0/0"
}

resource "aws_eip" "cloudrock-eip" {
  
   tags = {
    Name = "cloudrock-eip"
  }
}

resource "aws_nat_gateway" "prod-nat-gateway" {
  allocation_id = "${aws_eip.cloudrock-eip.id}"
  subnet_id     = "${aws_subnet.prod-pub-sub1.id}"

   tags = {
    Name = "prod-nat-gateway"
  }
}

output aws_nat_gateway {
  value       = "aws_eip.prod-nat-gateway.public_ip"
}

resource "aws_route_table" "instance" {
  vpc_id = aws_vpc.cloudrock-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.prod-nat-gateway.id
  }
}




  


