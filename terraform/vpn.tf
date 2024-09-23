resource "aws_instance" "openvpn" {
  ## OpenVPN AMI from marketplace
  ami           = "ami-0f6f5a74e666160bb"
  instance_type = "t3.medium"

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.openvpn_sg.id]

  associate_public_ip_address = true
  user_data                   = local.vpn_user_data

  tags = {
    Name = "OpenVPN"
  }


}