output "arm_public_ip" {
  value = oci_core_instance.vm_instance_ampere.public_ip
}

output "arm_public_state" {
  value = oci_core_instance.vm_instance_ampere.state
}
