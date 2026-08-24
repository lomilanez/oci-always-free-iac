output "instance_public_ip" {
  value       = oci_core_instance.always_free_vm.public_ip
  description = "The public IP address assigned to the compute instance"
}
