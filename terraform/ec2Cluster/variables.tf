variable "name" {
  description = "Name of the resources"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "internal" {
  description = "Is the loadbalncer internt-facing or internal true for internal"
  type        = bool
  default     = false
}


variable "tags" {
  description = "EC2 tags associated with instance"
  type        = map(string)

}

variable "vpc_cidr_block" {
  description = "VPC cidr block"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

