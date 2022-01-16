terraform {
  backend "s3" {
    bucket = "nan-s3-bucket"
    key    = "terraform/backend"
  }
}

locals {
  env_name         = "sandbox"
  aws_region       = "ap-notheast-2"
  k8s_cluster_name = "ms-cluster"
}

# Network Configuration

# EKS Configuration

# GitOps Configuration

