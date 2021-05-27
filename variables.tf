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

variable "iam_path" {
  type        = string
  description = "(Optional) The path for all IAM roles."
  default     = "/ekstf/"
}

variable "instance_types" {
  type        = list(string)
  description = "(Optional) EKS worker node instance types."
  default     = ["m5.xlarge"]
}

variable "capacity_type" {
  type        = string
  description = "(Optional) EKS worker node capacity type."
  default     = "ON_DEMAND"
}

variable "disk_size" {
  type        = number
  description = "(Optional) Disk size in GiB."
  default     = 100
}

variable "disk_type" {
  type        = string
  description = "(Optional) Disk type."
  default     = "gp2"
}