module "aurora" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name            = "${local.name}-aurora"
  engine          = "aurora-postgresql"
  engine_version  = "15"
  master_username = "root"
  storage_type    = "aurora-iopt1"
  instances = {
    1 = {
      identifier              = "db1"
      instance_class          = "db.r5.large"
      db_parameter_group_name = "default.aurora-postgresql15"
    }
    2 = {
      identifier     = "db2"
      instance_class = "db.r5.large"
    }
    3 = {
      identifier     = "db3"
      instance_class = "db.r5.large"
      promotion_tier = 15
    }
  }

  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.database_subnet_group_name
  apply_immediately    = true
  skip_final_snapshot  = true

  engine_lifecycle_support          = "open-source-rds-extended-support-disabled"
  create_db_cluster_parameter_group = false
  create_db_parameter_group         = false



}