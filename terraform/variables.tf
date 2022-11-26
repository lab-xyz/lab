variable "compartment_name" {
  description = "Name of OCI compartment"
  type        = string
}

variable "tenancy_ocid" {
  description = "Tenancy OCID."
  type        = string
}

variable "user_ocid" {
  description = "User OCID."
  type        = string
}

variable "vm_image_arm" {
  description = "The OCID of the arm VM image to deploy."
  type        = string
}

variable "vm_name_template" {
  description = ""
  type        = string
}

variable "region" {
  description = "The name of the OCI resource region."
  type        = string
  default     = "us-ashburn-1"
}

variable "fingerprint" {
  description = "Fingerprint of the public API key from OCI."
  type        = string
}

variable "private_key_path" {
  description = "Location of the .pem API private key file from OCI."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH pubkey string"
  type        = string
}
