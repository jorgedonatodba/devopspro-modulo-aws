resource "aws_vpc" "avg_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "avg-vpc"
  }
}

resource "aws_subnet" "avg_subnet_publica" {
  vpc_id     = aws_vpc.avg_vpc.id
  cidr_block = "10.0.0.0/24"

  #map_public_ip_on_launch = true

  #depends_on = [aws_internet_gateway.avg_igw]


  tags = {
    Name = "avg-subnet-publica"
  }
}

resource "aws_subnet" "avg_subnet_privada" {
  vpc_id     = aws_vpc.avg_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "avg-subnet-privada"
  }
}

resource "aws_internet_gateway" "avg_igw" {
  #vpc_id = aws_vpc.avg_vpc.id

  tags = {
    Name = "avg-igw"
  }
}

resource "aws_internet_gateway_attachment" "avg_iga" {
  internet_gateway_id = aws_internet_gateway.avg_igw.id
  vpc_id              = aws_vpc.avg_vpc.id
}

resource "aws_eip" "avg_ae" {
  depends_on = [aws_internet_gateway.avg_igw]

  tags = {
    Name = "avg-ae"
  }
}

resource "aws_nat_gateway" "avg_ngw" {
  allocation_id = aws_eip.avg_ae.id
  subnet_id     = aws_subnet.avg_subnet_publica.id

  tags = {
    Name = "avg-ngw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.avg_igw]
}

resource "aws_route_table" "avg_rt_publica" {
  vpc_id = aws_vpc.avg_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.avg_igw.id
  }

  tags = {
    Name = "avg-rt-publica"
  }
}

resource "aws_route_table_association" "avg_arta_a" {
  subnet_id      = aws_subnet.avg_subnet_publica.id
  route_table_id = aws_route_table.avg_rt_publica.id
}

resource "aws_route_table" "avg_rt_privada" {
  vpc_id = aws_vpc.avg_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.avg_ngw.id
  }

  tags = {
    Name = "avg-rt-privada"
  }
}

resource "aws_route_table_association" "avg_arta_b" {
  subnet_id      = aws_subnet.avg_subnet_privada.id
  route_table_id = aws_route_table.avg_rt_privada.id
}