resource "oci_core_vcn" "test_vcn" {
  cidr_block     = "10.0.0.0/16"
  display_name   = "tf-test-vcn"
  compartment_id = var.tenancy_ocid
}

output "vcn_id" {
  description = "The OCID of the created VCN"
  value       = oci_core_vcn.test_vcn.id
}
