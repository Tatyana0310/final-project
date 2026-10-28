resource "yandex_vpc_network" "cloud-net" {
  name = "cloud-net"
}
resource "yandex_vpc_subnet" "public-zone-a" {
  name           = "public-zone-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.cloud-net.id
  v4_cidr_blocks = ["10.10.1.0/24"]
}
resource "yandex_vpc_subnet" "private-zone-a" {
  name           = "private-zone-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.cloud-net.id
  v4_cidr_blocks = ["10.10.2.0/24"]
  route_table_id = yandex_vpc_route_table.private-rout.id
}
resource "yandex_vpc_subnet" "private-zone-d" {
  name           = "private-zone-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.cloud-net.id
  v4_cidr_blocks = ["10.10.3.0/24"]
  route_table_id = yandex_vpc_route_table.private-rout.id
}
resource "yandex_vpc_gateway" "nat-gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}
}
resource "yandex_vpc_route_table" "private-rout" {
  name       = "private-rout"
  network_id = yandex_vpc_network.cloud-net.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat-gateway.id
  }
}
resource "yandex_vpc_subnet" "public-zone-e" {
  name           = "public-zone-e"
  zone           = "ru-central1-e"
  network_id     = yandex_vpc_network.cloud-net.id
  v4_cidr_blocks = ["10.10.4.0/24"]
}


resource "yandex_vpc_subnet" "private-zone-e" {
  name           = "private-zone-e"
  zone           = "ru-central1-e"
  network_id     = yandex_vpc_network.cloud-net.id
  v4_cidr_blocks = ["10.10.5.0/24"]
  route_table_id = yandex_vpc_route_table.private-rout.id
}
resource "yandex_vpc_subnet" "public-zone-d" {
  name           = "public-zone-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.cloud-net.id
  v4_cidr_blocks = ["10.10.6.0/24"]
}