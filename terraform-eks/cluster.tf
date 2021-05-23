locals {
  cluster_name = "test-mbazych"
}

module "vpc" {
  source = "git::ssh://git@github.com/reactiveops/terraform-vpc.git?ref=v5.0.1"

  aws_region = "eu-central-1"
  az_count   = 3
  aws_azs    = "eu-central-1a, eu-central-1b, eu-central-1c"

  global_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

module "eks" {
  source          = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v12.1.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  vpc_id          = module.vpc.aws_vpc_id
  subnets         = module.vpc.aws_subnet_private_prod_ids

  node_groups = {
    eks_nodes = {
      desired_capacity = 3
      max_capacity     = 3
      min_capaicty     = 3

      instance_type = "t2.small"
    }
  }

  manage_aws_auth = false
}
