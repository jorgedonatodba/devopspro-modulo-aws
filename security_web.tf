resource "aws_security_group" "avg_sg_web" {
  name        = "avg_sg_web"
  description = "Regras para FW de app"
  vpc_id      = aws_vpc.avg_vpc.id

  tags = {
    Name = "avg-sg-web"
  }
}

resource "aws_vpc_security_group_ingress_rule" "avg_sg_web_ingress_http_ipv4" {
  security_group_id = aws_security_group.avg_sg_web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "avg_sg_web_ingress_https_ipv4" {
  security_group_id = aws_security_group.avg_sg_web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "avg_sg_web_ingress_ssh_ipv4" {
  security_group_id = aws_security_group.avg_sg_web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# resource "aws_vpc_security_group_ingress_rule" "avg_sg_web_allow_dns_ipv4" {
#   security_group_id = aws_security_group.avg_sg_web.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 53
#   ip_protocol       = "tcp"
#   to_port           = 53
# }

resource "aws_vpc_security_group_egress_rule" "avg_sg_web_egress_https_traffic_ipv4" {
  security_group_id = aws_security_group.avg_sg_web.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "avg_sg_web_egress_http_traffic_ipv4" {
  security_group_id = aws_security_group.avg_sg_web.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "avg_sg_web_egress_dns_tcp_traffic_ipv4" {
  security_group_id = aws_security_group.avg_sg_web.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 53
  ip_protocol = "tcp"
  to_port     = 53
}

resource "aws_vpc_security_group_egress_rule" "avg_sg_web_egress_dns_udp_traffic_ipv4" {
  security_group_id = aws_security_group.avg_sg_web.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 53
  ip_protocol = "udp"
  to_port     = 53
}

resource "aws_vpc_security_group_egress_rule" "avg_sg_web_egress_ssh_traffic_ipv4" {
  security_group_id = aws_security_group.avg_sg_web.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "avg_sg_web_egress_mongodb_traffic_ipv4" {
  security_group_id = aws_security_group.avg_sg_web.id

  cidr_ipv4   = "10.0.1.0/24"
  from_port   = 27017
  ip_protocol = "tcp"
  to_port     = 27017
}

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
#   security_group_id = aws_security_group.avg_sg_web.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }

resource "aws_network_acl" "avg_nacl_publica" {
  vpc_id     = aws_vpc.avg_vpc.id
  subnet_ids = [aws_subnet.avg_subnet_publica.id]

  #HTTP
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  #HTTPS
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  #SSH
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  #Portas efemeras
  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  #DNS TCP
  ingress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 53
    to_port    = 53
  }

  #DNS UDP
  ingress {
    protocol   = "udp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 53
    to_port    = 53
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

  #SSH
  egress {
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  tags = {
    Name = "avg-nacl-publica"
  }
}