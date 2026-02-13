resource "aws_security_group" "avg_sg_db" {
  name        = "avg_sg_db"
  description = "Regras para FW de db"
  vpc_id      = aws_vpc.avg_vpc.id

  tags = {
    Name = "avg-sg-db"
  }
}

resource "aws_vpc_security_group_ingress_rule" "avg_sg_db_ingress_mongodb_ipv4" {
  security_group_id = aws_security_group.avg_sg_db.id
  #cidr_ipv4         = "0.0.0.0/0"
  referenced_security_group_id = aws_security_group.avg_sg_web.id
  from_port                    = 27017
  ip_protocol                  = "tcp"
  to_port                      = 27017
}

resource "aws_vpc_security_group_ingress_rule" "avg_sg_db_ingress_ssh_ipv4" {
  security_group_id = aws_security_group.avg_sg_db.id
  cidr_ipv4         = aws_vpc.avg_vpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "avg_sg_db_egress_https_traffic_ipv4" {
  security_group_id = aws_security_group.avg_sg_db.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "avg_sg_db_egress_http_traffic_ipv4" {
  security_group_id = aws_security_group.avg_sg_db.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "avg_sg_db_egress_dns_tcp_traffic_ipv4" {
  security_group_id = aws_security_group.avg_sg_db.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 53
  ip_protocol = "tcp"
  to_port     = 53
}

resource "aws_vpc_security_group_egress_rule" "avg_sg_db_egress_dns_udp_traffic_ipv4" {
  security_group_id = aws_security_group.avg_sg_db.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 53
  ip_protocol = "udp"
  to_port     = 53
}

# resource "aws_vpc_security_group_egress_rule" "avg_sg_db_egress_ssh_traffic_ipv4" {
#   security_group_id = aws_security_group.avg_sg_db.id

#   cidr_ipv4   = "0.0.0.0/0"
#   from_port   = 22
#   ip_protocol = "tcp"
#   to_port     = 22
# }

resource "aws_network_acl" "avg_nacl_privada" {
  vpc_id     = aws_vpc.avg_vpc.id
  subnet_ids = [aws_subnet.avg_subnet_privada.id]

  #Mongodb
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 27017
    to_port    = 27017
  }

  #SSH
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  #Portas efemeras
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  #Portas efemeras
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  #HTTP
  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  #HTTPS
  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  #DNS TCP
  egress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 53
    to_port    = 53
  }

  #DNS UDP
  egress {
    protocol   = "udp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 53
    to_port    = 53
  }

  # #SSH
  # egress {
  #   protocol   = "tcp"
  #   rule_no    = 150
  #   action     = "allow"
  #   cidr_block = "0.0.0.0/0"
  #   from_port  = 22
  #   to_port    = 22
  # }

  tags = {
    Name = "avg-nacl-privada"
  }
}