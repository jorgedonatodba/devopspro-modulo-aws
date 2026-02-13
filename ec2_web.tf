# data "aws_ami" "amzn-linux-2023-ami" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["al2023-ami-2023.*-x86_64"]
#   }
# }

resource "aws_key_pair" "avg_kp_ssh" {
  key_name   = "avg_kp_ssh"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "avg_ec2_web" {
  #ami           = data.aws_ami.amzn-linux-2023-ami.id
  ami                         = "ami-0b6c6ebed2801a5cb"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.avg_subnet_publica.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.avg_sg_web.id]
  key_name                    = aws_key_pair.avg_kp_ssh.key_name
  user_data                   = file("./install_docker.sh")

  tags = {
    Name = "avg_ec2_web"
  }
}