variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "availability_domain" {}
variable "instance_shape" {
  default = "VM.Standard.A1.Flex" # same as KubeMaster
}
variable "private_key" {
  description = "The OCI API private key, provided as a secret environment variable from ADO"
  type        = string
  sensitive   = true
}
