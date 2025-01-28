resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  version = var.kubernetes_version

  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = [aws_security_group.nodes.id] 
    endpoint_public_access = true 
    endpoint_private_access = true
  }

  tags = var.tags
}

resource "aws_security_group" "nodes" {
  name        = "eks-nodes"
  description = "Allow ingress for nodes"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }

}

resource "aws_iam_role" "eks_role" {
  name = "eks-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy" "eks_policy" {
  name = "eks-policy"
  role = aws_iam_role.eks_role.name

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:Describe*",
          "ec2:CreateSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "iam:PassRole",
          "iam:GetRole",
          "iam:ListRoles",
          "iam:CreateServiceLinkedRole",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:CreateVpcEndpoint",
          "ec2:DescribeVpcEndpoints",
          "ec2:DeleteVpcEndpoint",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeRulePriorities", 
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:DescribeTargetGroupAttributes", 
          "autoscaling:DescribeAutoScalingGroups", 
          "autoscaling:DescribeLaunchConfigurations", 
          "autoscaling:DescribeLaunchTemplates", 
          "autoscaling:DescribeScalingActivities", 
          "autoscaling:DescribeScheduledActions", 
          "autoscaling:DescribeAutoScalingInstances", 
          "autoscaling:DescribeTags", 
          "autoscaling:DescribeTerminationPolicyTypes", 
          "autoscaling:DescribeWarmPool"
        ],
        "Resource": "*" 
      }
    ]
  })
}