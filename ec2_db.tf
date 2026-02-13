resource "aws_instance" "avg_ec2_db" {
  #ami           = data.aws_ami.amzn-linux-2023-ami.id
  ami                    = "ami-0b6c6ebed2801a5cb"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.avg_subnet_privada.id
  vpc_security_group_ids = [aws_security_group.avg_sg_db.id]
  key_name               = aws_key_pair.avg_kp_ssh.key_name
  user_data              = file("./install_docker.sh")

  tags = {
    Name = "avg_ec2_db"
  }
}