output "x64_public_ip0" {
  value = oci_core_instance.vm_instance_x86_64[0].public_ip
}
output "x64_public_ip1" {
  value = oci_core_instance.vm_instance_x86_64[1].public_ip
}
