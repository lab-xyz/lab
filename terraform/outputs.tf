output "arm_public_ip0" {
  value = oci_core_instance.vm_instance_ampere[0].public_ip
}

output "arm_public_ip1" {
  value = oci_core_instance.vm_instance_ampere[1].public_ip
}
