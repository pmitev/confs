variable "vm_name" {
  type    = string
  default = "VM"
}


variable "image_U24" {
  type    = string
  default = "Ubuntu 20.04 LTS (Focal Fossa) - latest"
}
variable "image_U24_id" {
  type    = string
  default = "b229a221-e685-4376-98a6-295d502bb41e"
}

variable "external_network" {
  type    = string
  default = "Public External IPv4 Network"
}

# UUID of external gateway
variable "external_gateway" {
  type    = string
  default = "8a2049af-7ff7-4303-b794-a6387dfee03d"
}

variable "dns_ip" {
  type    = list(string)
  default = ["8.8.8.8", "8.8.8.4"]
}
