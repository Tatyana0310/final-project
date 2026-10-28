data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}


resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-zone-a.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.bastion-security-group.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }

  #scheduling_policy {
  #  preemptible = true
  #}
  
  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }

}
resource "yandex_compute_instance" "web-1" {
  name        = "web-1"
  hostname    = "web-1"
  platform_id = "standard-v3"
  zone        = "ru-central1-e"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-zone-e.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.web-security-group.id]
  }

  metadata = {
    user-data = file("cloud-init.yml")
  }

  #scheduling_policy {
  #  preemptible = true
  #}

   lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }
}
resource "yandex_compute_instance" "web-2" {
  name        = "web-2"
  hostname    = "web-2"
  platform_id = "standard-v3"
  zone        = "ru-central1-d"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-zone-d.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.web-security-group.id]
  }

  metadata = {
    user-data = file("cloud-init.yml")
  }

  #scheduling_policy {
  #  preemptible = true
  #}

  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }
}
resource "yandex_compute_instance" "zabbix" {
  name        = "zabbix"
  hostname    = "zabbix"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-zone-a.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.zabbix-security-group.id]
  }

  metadata = {
        user-data = file("cloud-init.yml")
  }

  #scheduling_policy {
  #  preemptible = true
  #}

  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }
}
resource "yandex_compute_instance" "kibana" {
  name        = "kibana"
  hostname    = "kibana"
  platform_id = "standard-v3"
  zone        = "ru-central1-d"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-zone-d.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.kibana-security-group.id]
  }

  metadata = {
       user-data = file("cloud-init.yml")
  }

  #scheduling_policy {
  #  preemptible = true
  #}

  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }
}

resource "yandex_compute_instance" "elasticsearch" {
  name        = "elasticsearch"
  hostname    = "elasticsearch"
  platform_id = "standard-v3"
  zone        = "ru-central1-e"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-zone-e.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.elasticsearch-security-group.id]
  }

  metadata = {
    user-data = file("cloud-init.yml")
  }

  #scheduling_policy {
  #  preemptible = true
  #}

  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }
}
