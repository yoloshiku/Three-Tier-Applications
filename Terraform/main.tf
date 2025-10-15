# ---------------------------------------
# Provider Configuration
# ---------------------------------------
provider "oci" {
  tenancy_ocid        = var.tenancy_ocid
  user_ocid           = var.user_ocid
  fingerprint         = var.fingerprint
  private_key_path    = var.private_key_path
  region              = var.region
}

# ---------------------------------------
# Data Sources (look up OCI resources)
# ---------------------------------------
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "ubuntu_2204_minimal_arm" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04 Minimal"
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# ---------------------------------------
# Create Compute Instance
# ---------------------------------------
resource "oci_core_instance" "vm_instance" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_name
  shape               = var.instance_shape

  create_vnic_details {
    subnet_id        = var.subnet_ocid
    assign_public_ip = true
    hostname_label   = var.instance_name
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oracle_linux.id
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
  }
}
