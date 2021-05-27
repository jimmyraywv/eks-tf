resource "aws_iam_role" "worker_node" {
  name = "terraform-eks-worker-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "worker_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.worker_node.name}"
}

resource "aws_iam_role_policy_attachment" "worker_node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.worker_node.name}"
}

resource "aws_iam_role_policy_attachment" "worker_node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.worker_node.name}"
}

resource "aws_iam_role_policy_attachment" "worker_node_AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = "${aws_iam_role.worker_node.name}"
}

resource "aws_iam_role_policy_attachment" "worker_node_KmsKeyUserSsmOps" {
  policy_arn = replace("arn:aws:iam::<ACCOUNT_ID>:policy/KmsKeyUserSsmOps", "<ACCOUNT_ID>", var.sensitive_account_id)
  role       = "${aws_iam_role.worker_node.name}"
}

resource "aws_iam_instance_profile" "worker_node_profile" {
  name = "terraform-eks-worker-profile"
  role = "${aws_iam_role.worker_node.name}"
}