variable "aws_profile" {
  description = "Default AWS profile"
  type        = string
  default     = "default"
}
variable "aws_region" {
  description = "Region"
  type        = string
  default     = "us-east-1"
}
variable "instance_name" {
  description = "Instance name"
  type        = string
  default     = "Generic instance"
}
variable "ami" {
  description = "Instance AMI"
  type        = string
  default     = "ami-007855ac798b5175e"
}
variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.nano"
}
variable "key_pair_name" {
  type    = string
  default = "generic_key_pair"
}
variable "key_algorithm" {
  type    = string
  default = "ED25519"
}
