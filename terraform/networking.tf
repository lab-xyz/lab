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
  security_list_ids = [oci_core_vcn.homelab_vcn.public-security-list.id]
  display_name   = "${var.compartment_name}-subnet"
  route_table_id    = oci_core_route_table.homelab_rt.id
}

resource "oci_core_security_list" "public-security-list" {
  compartment_id = oci_identity_compartment.homelab.id
  vcn_id         = oci_core_vcn.homelab_vcn.id
  display_name   = "public-security-list"

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    description = "SSH traffic"

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "17"
    description = "Wireguard"

    tcp_options {
      min = 51820
      max = 51820
    }
  }
}

resource "oci_core_network_security_group_security_rule" "homelab-network-security-group-list-ingress" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction                 = "INGRESS"
  source                    = oci_core_network_security_group.nsg.id
  source_type               = "NETWORK_SECURITY_GROUP"
  protocol                  = "all"
  stateless                 = true
}

resource "oci_core_network_security_group_security_rule" "homelab-network-security-group-list-egress" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction                 = "EGRESS"
  destination               = oci_core_network_security_group.nsg.id
  destination_type          = "NETWORK_SECURITY_GROUP"
  protocol                  = "all"
  stateless                 = true
}
