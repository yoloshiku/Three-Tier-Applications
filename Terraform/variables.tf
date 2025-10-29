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
variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}
