#
# Variables Configuration
#

variable "cluster-name" {
  default = "terraform-eks-ngwa"
  type    = string
}
variable "key_pair_name" {
  default = "NGWA91"
}
variable "eks_node_instance_type" {
  default = "t2.medium"

}
