terraform {
  backend "s3" {
    bucket = "nan-s3-bucket"
    key    = "terraform/backend"
  }
}

locals {
  env_name         = "sandbox"
  aws_region       = "ap-northeast-2"
  k8s_cluster_name = "ms-cluster"
}

# Network Configuration
module "aws-network" {
  source = "github.com/jshong0907/module-aws-network"

  env_name              = local.env_name
  vpc_name              = "joonshik-VPC"
  cluster_name          = local.k8s_cluster_name
  aws_region            = local.aws_region
  main_vpc_cidr         = "10.10.0.0/16"
  public_subnet_a_cidr  = "10.10.0.0/18"
  public_subnet_b_cidr  = "10.10.64.0/18"
  private_subnet_a_cidr = "10.10.128.0/18"
  private_subnet_b_cidr = "10.10.192.0/18"
}

# EKS Configuration
module "aws-eks" {
  source = "github.com/jshong0907/module-aws-kubernetes"
  
  ms_namespace       = "microservices"
  env_name           = local.env_name
  aws_region         = local.aws_region
  cluster_name       = local.k8s_cluster_name
  vpc_id             = module.aws-network.vpc_id
  cluster_subnet_ids = module.aws-network.subnet_ids


  nodegroup_subnet_ids     = module.aws-network.private_subnet_ids
  nodegroup_disk_size      = "20"
  nodegroup_instance_types = ["t2.micro"]
  nodegroup_desired_size   = 1
  nodegroup_min_size       = 1
  nodegroup_max_size       = 3
}

# GitOps Configuration

