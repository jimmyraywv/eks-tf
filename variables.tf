variable "cluster_name" {
  type        = string
  description = "(Optional) The cluster name."
  default     = "eks-tf"
}

variable "cluster_version" {
  type        = string
  description = "(Optional) The cluster name."
  default     = "1.20"
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::<ACCOUNT_ID>:role/admin"
      username = "admin"
      groups   = ["system:masters"]
    },
  ]
}


