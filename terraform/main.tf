terraform {
    required_version = ">= 1.3.0"

    cloud {
        organization = "cjriddz"

        workspaces {
          name = "xyz-homelab"
        }
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
