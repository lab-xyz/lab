resource "oci_core_instance" "vm_instance_ampere" {
    availability_domain                 = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id                      = oci_identity_compartment.tf-compartment.id
    shape                               = "VM.Standard.A1.Flex"
    display_name                        = join("", [var.vm_name_template, "-arm"]) 
    is_pv_encryption_in_transit_enabled = true 
    preserve_boot_volume = false

    shape_config {
        memory_in_gbs = 24
        ocpus         = 4
    }

    metadata = {
        ssh_authorized_keys = var.ssh_public_key
    }

    source_details {
        source_id   = var.vm_image_arm
        source_type = "image"
        boot_volume_size_in_gbs = 200
    }

    create_vnic_details {
        assign_public_ip          = true
        subnet_id                 = oci_core_subnet.homelab_subnet.id
        assign_private_dns_record = true
        hostname_label            = join("", [var.vm_name_template, "-arm"])
        nsg_ids                   = [oci_core_network_security_group.homelab_nsg.id]
    }
}

resource "oci_core_vnic_attachment" "secondary_vnic" {
    create_vnic_details {
        assign_public_ip          = true
        subnet_id                 = oci_core_subnet.homelab_subnet.id
        hostname_label            = join("", [var.vm_name_template, "-arm-2"])
        nsg_ids                   = [oci_core_network_security_group.homelab_nsg.id]
    }
    instance_id = oci_core_instance.vm_instance_ampere.id
}
