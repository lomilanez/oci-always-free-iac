resource "oci_core_instance" "always_free_vm" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = "always-free-ampere-vm"
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.ocpus
    memory_in_gbs = var.memory_in_gbs
  }

  source_details {
    source_type             = "image"
    source_id               = var.instance_image_id
    boot_volume_size_in_gbs = var.boot_volume_size_gbs
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
    nsg_ids          = [var.nsg_id]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}
