resource "oci_identity_compartment" "tf-compartment" {
    compartment_id = var.tenancy_ocid
    description = "Compartment for Terraform resources."
    name = var.compartment_name
}

# Source from https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_availability_domains

# <tenancy-ocid> is the compartment OCID for the root compartment.
# Use <tenancy-ocid> for the compartment OCID.

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_boot_volumes" "homelab_boot_volumes" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[3].name
  compartment_id      = oci_identity_compartment.tf-compartment.id
}
