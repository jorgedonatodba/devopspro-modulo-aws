output "web_ip" {
  value = aws_instance.avg_ec2_web.public_ip
}

output "db_ip" {
  value = aws_instance.avg_ec2_db.private_ip
}