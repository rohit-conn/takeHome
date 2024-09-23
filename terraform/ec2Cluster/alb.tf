module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name = var.name

  vpc_id   = var.vpc_id
  subnets  = local.lb_subnets
  internal = var.internal

  # For example only
  enable_deletion_protection = false

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = var.vpc_cidr_block
    }
  }

  listeners = {
    ex_http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "ex-instance"
      }
    }
  }

  target_groups = {
    ex-instance = {
      name_prefix          = "h1"
      protocol             = "HTTP"
      port                 = 80
      target_type          = "instance"
      deregistration_delay = 10
      vpc_id               = var.vpc_id
      create_attachment    = false
      # load_balancing_algorithm_type     = "weighted_random"
      # load_balancing_anomaly_mitigation = "on"
      # load_balancing_cross_zone_enabled = false
    }
  }
  //tags = local.tags
}
