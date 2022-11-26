resource "oci_core_volume" "block_volume_arm" {
  compartment_id       = oci_identity_compartment.tf-compartment.id
  availability_domain  = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name         = join("-", [var.vm_name_template, "block", "volume"])
  size_in_gbs          = 150
  is_auto_tune_enabled = true
}

resource "oci_core_volume_attachment" "volume_attachment" {
  attachment_type                     = "paravirtualized"
  instance_id                         = oci_core_instance.vm_instance_ampere.id
  volume_id                           = oci_core_volume.block_volume_arm.id
  display_name                        = "oci_block"
  is_pv_encryption_in_transit_enabled = true
  is_read_only                        = false
}
