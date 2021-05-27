module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name    #local.cluster_name
  cluster_version = var.cluster_version   #"1.20"
  subnets         = module.vpc.private_subnets
  enable_irsa     = true
  # manage_cluster_iam_resources = false
  # cluster_iam_role_name = "admin"
  iam_path = var.iam_path
  #workers_role_name = aws_iam_role.worker_node.name
  map_roles    = var.sensitive_map_roles
  manage_worker_iam_resources = false

  tags = {
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id

  # workers_group_defaults = {
  #   root_volume_type = "gp2"
  # }

  # worker_groups = [
  #   {
  #     name                          = "worker-group-1"
  #     instance_type                 = "t2.small"
  #     additional_userdata           = "echo foo bar"
  #     asg_desired_capacity          = 2
  #     additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
  #     # iam_instance_profile_name = aws_iam_instance_profile.worker_node_profile.name
  #   },
  #   {
  #     name                          = "worker-group-2"
  #     instance_type                 = "t2.medium"
  #     additional_userdata           = "echo foo bar"
  #     additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
  #     asg_desired_capacity          = 1
  #     # iam_instance_profile_name = aws_iam_instance_profile.worker_node_profile.name
  #   },
  # ]

  node_groups = {
    ng1 = {
      name             = "ng1"
      desired_capacity = 3
      max_capacity     = 3
      min_capacity     = 3
      capacity_type    = var.capacity_type
      instance_types   = var.instance_types
      iam_role_arn     = aws_iam_role.worker_node.arn
      disk_size        = var.disk_size
      disk_type        = var.disk_type
    }
  }

  cluster_encryption_config = [
    {
      provider_key_arn = var.sensitive_kms_key_eks_secrets_arn
      resources        = ["secrets"]
    }
  ]

}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# resource "aws_eks_node_group" "node_group_1" {
#   cluster_name    = aws_eks_cluster.example.name
#   node_group_name = "ng1"
#   node_role_arn   = aws_iam_role.example.arn
#   subnet_ids      = aws_subnet.example[*].id

#   scaling_config {
#     desired_size = 3
#     max_size     = 3
#     min_size     = 3
#   }

#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   depends_on = [
#     aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
#   ]
# }

