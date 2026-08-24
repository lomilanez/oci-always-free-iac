variable "tenancy_ocid" { type = string }
variable "user_ocid" { type = string }
variable "fingerprint" { type = string }
variable "private_key_path" { type = string }
variable "region" { type = string }
variable "compartment_id" { type = string }
variable "availability_domain" { type = string }
variable "ssh_public_key" { type = string }

variable "oracle_linux_image_ocid" {
  type        = string
  description = "The region-specific OCID for the Oracle Linux target image"
}
