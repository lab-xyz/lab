terraform {
    required_version = ">= 1.3.0"

    backend "local" {
        path = "terraform.tfstate"
    }

    required_providers {
        oci = {
            source = "oracle/oci"
            version = ">= 4.90.0"
        }
    }
}

provider "oci" {
    tenancy_ocid  =  var.tenancy_ocid
    user_ocid     =  var.user_ocid
    private_key   =  var.private_key
    fingerprint   =  var.fingerprint
    region        =  var.region
}
