output "arm_public_ip" {
  value = oci_core_instance.vm_instance_ampere[0].public_ip
}

output "x86_64_public_ip" {
  value = oci_core_instance.vm_instance_x86_64[0].public_ip
}
