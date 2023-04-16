resource "oci_core_instance" "vm_instance_ampere" {
    count = 1
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
        boot_volume_size_in_gbs = 100
    }

    create_vnic_details {
        assign_public_ip          = true
        subnet_id                 = oci_core_subnet.homelab_subnet.id
        assign_private_dns_record = true
        hostname_label            = join("", [var.vm_name_template, "-arm"])
        nsg_ids                   = [oci_core_network_security_group.homelab_nsg.id]
    }

    connection {
        type        = "ssh"
        host        = "${oci_core_instance.vm_instance_ampere.public_ip}"
        user        = "ubuntu"
        private_key = "${var.ssh_private_key}"
    }

    provisioner "remote-exec" {
        inline = [
            "echo 'This instance was provisioned by Terraform in Oracle Cloud region ${var.region}.' | sudo tee /etc/motd",
            "sudo apt update",
            "sudo apt update",
            "sudo apt install -y ansible git",
            "ansible-pull -U https://github.com/lab-xyz/lab.git -e k3s_master_ip=${var.k3s_master_ip} -e k3s_token=${var.k3s_token} -e k3s_public_ip=${oci_core_instance.vm_instance_ampere.public_ip} ansible/site.yml",
        ]
    }

}

resource "oci_core_instance" "vm_instance_x86_64" {
    count = 1
    availability_domain                 = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id                      = oci_identity_compartment.tf-compartment.id
    shape                               = "VM.Standard.E2.1.Micro"
    display_name                        = join("", [var.vm_name_template, "-amd64"]) 
    is_pv_encryption_in_transit_enabled = true 
    preserve_boot_volume = false

    metadata = {
        ssh_authorized_keys = var.ssh_public_key
    }

    source_details {
        source_id   = var.vm_image_arm
        source_type = "image"
        boot_volume_size_in_gbs = 100
    }

    create_vnic_details {
        assign_public_ip          = true
        subnet_id                 = oci_core_subnet.homelab_subnet.id
        assign_private_dns_record = true
        hostname_label            = join("", [var.vm_name_template, "-amd64"])
        nsg_ids                   = [oci_core_network_security_group.homelab_nsg.id]
    }

    connection {
        type        = "ssh"
        host        = "${oci_core_instance.vm_instance_ampere.public_ip}"
        user        = "ubuntu"
        private_key = "${var.ssh_private_key}"
    }

    provisioner "remote-exec" {
        inline = [
            "echo 'This instance was provisioned by Terraform in Oracle Cloud region ${var.region}.' | sudo tee /etc/motd",
            "sudo apt update",
            "sudo apt update",
            "sudo apt install -y ansible git",
            "ansible-pull -U https://github.com/lab-xyz/lab.git -e k3s_master_ip=${var.k3s_master_ip} -e k3s_token=${var.k3s_token} -e k3s_public_ip=${oci_core_instance.vm_instance_ampere.public_ip} ansible/site.yml",
        ]
    }

}
