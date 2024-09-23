data "aws_availability_zones" "available" {}

locals {
  name   = "payabl"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  nginx_tags = {
    Role      = "nginx"
  }

  app_tags = {
    Role = "app"
  }

  vpn_user_data = <<-EOT
        #!/bin/bash

        apt-get update -y
        apt-get upgrade -y

        /usr/local/openvpn_as/bin/ovpn-init --force

        echo "openvpn:your_password" | chpasswd

        /usr/local/openvpn_as/scripts/sacli --key "vpn.server.daemon.0.listen.port" --value "443" ConfigPut
        /usr/local/openvpn_as/scripts/sacli --key "vpn.daemon.udp.port" --value "1194" ConfigPut
        /usr/local/openvpn_as/scripts/sacli --key "vpn.server.daemon.enable" --value "true" ConfigPut


        /usr/local/openvpn_as/scripts/sacli --user openvpn --key "type" --value "admin" UserPropPut

        systemctl start openvpnas


        systemctl enable openvpnas

        reboot
    EOT

}

