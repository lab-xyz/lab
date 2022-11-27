resource "oci_core_vcn" "homelab_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = oci_identity_compartment.tf-compartment.id
  display_name   = var.compartment_name
  dns_label      = "vcn"
}

resource "oci_core_network_security_group" "homelab_nsg" {
  compartment_id = oci_identity_compartment.tf-compartment.id
  display_name   = "${var.compartment_name}-nsg"
  vcn_id         = oci_core_vcn.homelab_vcn.id
}

resource "oci_core_internet_gateway" "homelab_ig" {
  compartment_id = oci_identity_compartment.tf-compartment.id
  display_name   = "${var.compartment_name}-ig"
  vcn_id         = oci_core_vcn.homelab_vcn.id
}

resource "oci_core_route_table" "homelab_rt" {
  compartment_id = oci_identity_compartment.tf-compartment.id
  vcn_id         = oci_core_vcn.homelab_vcn.id
  display_name   = "${var.compartment_name}-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.homelab_ig.id
  }
}
resource "oci_core_subnet" "homelab_subnet" {
  #Required
  cidr_block     = "10.0.0.0/24"
  compartment_id = oci_identity_compartment.tf-compartment.id
  vcn_id         = oci_core_vcn.homelab_vcn.id
  dns_label      = "homelab"

  # Provider code tries to maintain compatibility with old versions.
  security_list_ids = [oci_core_vcn.homelab_vcn.default_security_list_id]
  display_name   = "${var.compartment_name}-subnet"
  route_table_id    = oci_core_route_table.homelab_rt.id
}
