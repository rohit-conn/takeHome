

locals {
  user_data = <<-EOT
    #!/bin/bash
    rpm -Uvh https://yum.puppetlabs.com/puppet-release-el-9.noarch.rpm
    yum update
    yum install puppet-agent -y

    cat << EOF > /opt/puppetlabs/facter/facts.d/aws_role.sh
    #!/bin/bash
    ROLE=`curl -s http://169.254.169.254/latest/meta-data/tags/instance/Role`
    echo "aws_role=\$ROLE"
    EOF

    chmod 755 /opt/puppetlabs/facter/facts.d/aws_role.sh

  EOT

  lb_subnets = var.internal ? var.private_subnets : var.public_subnets
}


data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "autoscaling_group" {
  source = "terraform-aws-modules/autoscaling/aws"

  name                = var.name
  min_size            = 1
  max_size            = 5
  desired_capacity    = 1
  health_check_type   = "EC2"
  vpc_zone_identifier = var.private_subnets

  # Launch template
  launch_template_name        = var.name
  launch_template_description = "ec2 cluster module"
  update_default_version      = true

  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  user_data     = base64encode(local.user_data)
  traffic_source_attachments = {
    ex-alb = {
      traffic_source_identifier = module.alb.target_groups["ex-instance"].arn
      traffic_source_type       = "elbv2"
    }
  }
  metadata_options = {
    http_tokens            = "optional"
    instance_metadata_tags = "enabled"
  }
  security_groups = [module.asg_sg.security_group_id]
  tags            = var.tags
}
# }

module "asg_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = var.name
  description = "Autoscale security group for ${var.name}"
  vpc_id      = var.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = var.tags
}
