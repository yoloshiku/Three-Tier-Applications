terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# ─────────────────────────────────────────────
#  Get existing subnet and image from OCI
# ─────────────────────────────────────────────

# Lookup existing subnet used by KubeMaster
data "oci_core_subnets" "existing" {
  compartment_id = var.compartment_ocid
  display_name   = "subnet-Internet-GW" # same subnet name as KubeMaster
}

# Lookup existing image (Ubuntu 22.04 or same as KubeMaster)
data "oci_core_images" "kube_image" {
  compartment_id = var.compartment_ocid
  operating_system = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape = var.instance_shape
}

# ─────────────────────────────────────────────
#  Create New Instance (KubeNode1)
# ─────────────────────────────────────────────
resource "oci_core_instance" "kubenode1" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "KubeNode1"
  shape               = var.instance_shape

  # Reuse existing subnet (same network as KubeMaster)
  create_vnic_details {
    subnet_id        = data.oci_core_subnets.existing.subnets[0].id
    assign_public_ip = true
    display_name     = "KubeNode1-VNIC"
    hostname_label   = "kubenode1"
  }

  # Same image as KubeMaster
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.kube_image.images[0].id
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
  }

  preserve_boot_volume = false
}

# ─────────────────────────────────────────────
#  Output Information
# ─────────────────────────────────────────────
output "kubenode1_public_ip" {
  value = oci_core_instance.kubenode1.public_ip
}

output "kubenode1_private_ip" {
  value = oci_core_instance.kubenode1.private_ip
}
