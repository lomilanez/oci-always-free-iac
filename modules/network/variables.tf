variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment where the network resources will be created"
}

variable "vcn_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The CIDR block for the main VCN"
}

variable "subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "The CIDR block for the public subnet"
}
