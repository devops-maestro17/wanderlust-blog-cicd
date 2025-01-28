# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Create the VPC and Subnets
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name        = "eks-vpc"
  cidr_block  = var.vpc_cidr
  azs         = ["us-east-1a", "us-east-1b", "us-east-1c"] 
  private_subnets = var.subnet_cidrs 
  enable_nat_gateway = true 
  tags        = var.tags
}

# Create the EKS Cluster
module "eks" {
  source  = "./modules/eks"

  region              = var.region
  cluster_name        = "my-eks-cluster" 
  kubernetes_version = var.kubernetes_version
  node_instance_type = var.node_instance_type
  node_group_count   = var.node_group_count
  node_count_per_group= var.node_count_per_group
  subnet_ids         = module.vpc.private_subnet_ids
  tags               = var.tags
}