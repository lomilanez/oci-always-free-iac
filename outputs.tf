output "always_free_vm_ip" {
  value       = module.compute_arm.instance_public_ip
  description = "Use this public IP address to connect via SSH to your new VM"
}
