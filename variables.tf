variable "region" {
  type        = string
  description = "AWS Region"
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR Block"
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  type        = list(string)
  description = "Subnet CIDR Blocks"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "node_instance_type" {
  type        = string
  description = "Node Instance Type"
  default     = "t3.medium"
}

variable "node_group_count" {
  type        = number
  description = "Number of Node Groups"
  default     = 1
}

variable "node_count_per_group" {
  type        = number
  description = "Number of Nodes per Group"
  default     = 3
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes Version"
  default     = "1.32" 
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}