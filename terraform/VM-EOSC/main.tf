#====================================================================================
# Public key ========================================================================
#====================================================================================
resource "openstack_compute_keypair_v2" "test-keypair" {
  name       = "terraform_keypair"
  public_key = var.key_pub
}

#====================================================================================
# Network ===========================================================================
#====================================================================================
resource "openstack_networking_network_v2" "network_1" {
  name           = "terraform_internal"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name        = "terraform_subnet"
  network_id  = openstack_networking_network_v2.network_1.id
  cidr        = "192.168.3.0/24"
  ip_version  = 4
  enable_dhcp = true
}

resource "openstack_networking_router_v2" "router_1" {
  name                = "terraform_router"
  admin_state_up      = true
  external_network_id = "80132485-a42a-42bf-a32f-85ed0dcf02d3" # PSNC-EXT-PUB1-EDU
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = openstack_networking_router_v2.router_1.id
  subnet_id = openstack_networking_subnet_v2.subnet_1.id
}


#====================================================================================
# Security group
#====================================================================================
resource "openstack_networking_secgroup_v2" "secgroup_1" {
  name        = "terraform_group"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_1" {
  for_each = var.safe_IPs
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 0
  port_range_max    = 0
  remote_ip_prefix  = each.key
  security_group_id = openstack_networking_secgroup_v2.secgroup_1.id
}

#====================================================================================
# Start Instance ====================================================================
#====================================================================================
resource "openstack_compute_instance_v2" "vm" {
  name = "VM"
  image_id        = "7816da3d-cc63-4f01-bc2a-832bf2391eb8"
  flavor_name     = "M1-NVME-2vCPU-8R-50D"
  key_pair        = "terraform_keypair"
  security_groups = ["default", "terraform_group"]

  depends_on = [ openstack_networking_secgroup_v2.secgroup_1 ]

  network {
    uuid = openstack_networking_network_v2.network_1.id
  }

  #block_device {
  #  uuid                  = "7816da3d-cc63-4f01-bc2a-832bf2391eb8"
  #  source_type           = "image"
  #  destination_type      = "volume"
  #  boot_index            = 0
  #  volume_size           = 100
  #  delete_on_termination = true
  #}

  #block_device {
  #  source_type           = "blank"
  #  destination_type      = "volume"
  #  volume_size           = 100
  #  boot_index            = 1
  #  delete_on_termination = true
  #}
}

#====================================================================================
# Allocate floating ip
#====================================================================================
resource "openstack_networking_floatingip_v2" "vm" {
  pool = "PSNC-EXT-PUB1-EDU"
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "vm" {
  floating_ip = openstack_networking_floatingip_v2.vm.address
  instance_id = openstack_compute_instance_v2.vm.id

  provisioner "local-exec" {
    command = "echo 'localhost ansible_connection=local\nVM ansible_host=${openstack_networking_floatingip_v2.vm.address} ansible_user=ubuntu' | tee hosts"
  }
}

output "instance_ip_addr" {
  value = openstack_networking_floatingip_v2.vm.address
}

resource "local_file" "hosts" {
  content         = "localhost ansible_connection=local\nVM ansible_host=${openstack_networking_floatingip_v2.vm.address} ansible_user=ubuntu\n"
  file_permission = "0644"
  filename        = "hosts"
}

resource "null_resource" "local_run" {
  triggers = { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "echo 'localhost ansible_connection=local\nVM ansible_host=${openstack_networking_floatingip_v2.vm.address} ansible_user=ubuntu' | tee hosts"
  }
}


## Create volume
#resource "openstack_blockstorage_volume_v2" "volume" {
#  name = "VM-volume"
#  size = 100
#}
#
## Attach volume to instance instance db
#resource "openstack_compute_volume_attach_v2" "volume" {
#  instance_id = openstack_compute_instance_v2.vm.id
#  volume_id   = openstack_blockstorage_volume_v2.volume.id
#}
