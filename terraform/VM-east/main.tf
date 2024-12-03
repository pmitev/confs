resource "openstack_compute_instance_v2" "vm" {
  name = "VM"
  #  image_id        = "eaf8c18b-9924-438a-8bbc-fbbb09248ce3"
  flavor_name     = "ssc.medium"
  key_pair        = "Default"
  security_groups = ["default", "ssh-whitelist"]

  network {
    name = "NAISS 2024/7-9 Internal IPv4 Network"
  }

  block_device {
    uuid                  = "b229a221-e685-4376-98a6-295d502bb41e"
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    volume_size           = 100
    delete_on_termination = true
  }

  #  block_device {
  #    source_type           = "blank"
  #    destination_type      = "volume"
  #    volume_size           = 100
  #    boot_index            = 1
  #    delete_on_termination = true
  #  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "vm" {
  pool = var.external_network
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "vm" {
  floating_ip = openstack_networking_floatingip_v2.vm.address
  instance_id = openstack_compute_instance_v2.vm.id

  provisioner "local-exec" {
    command = "echo Instance_IP_addr '${openstack_networking_floatingip_v2.vm.address}' | tee log.txt"
  }
}

output "instance_ip_addr" {
  value = openstack_networking_floatingip_v2.vm.address
}

resource "local_file" "log" {
  content         = "instance_ip_addr: ${openstack_networking_floatingip_v2.vm.address}\n"
  file_permission = "0644"
  filename        = "log.txt"
}

resource "null_resource" "local_run" {
  triggers = { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "echo Instance_IP_addr: '${openstack_networking_floatingip_v2.vm.address}' | tee -a log.txt"
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
