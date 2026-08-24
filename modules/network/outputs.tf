output "subnet_id" {
  value       = oci_core_subnet.public_subnet.id
  description = "The OCID of the generated public subnet"
}

output "nsg_id" {
  value       = oci_core_network_security_group.vm_nsg.id
  description = "The OCID of the network security group for the VM"
}
