module "app_cluster" {
  source = "./ec2Cluster"

  name            = "app-cluster"
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
  vpc_cidr_block  = module.vpc.vpc_cidr_block
  vpc_id          = module.vpc.vpc_id
  tags            = local.app_tags
  internal        = true

}