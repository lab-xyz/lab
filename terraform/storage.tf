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
