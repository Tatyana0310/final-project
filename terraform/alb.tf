resource "yandex_alb_target_group" "target-group" {   # обозначаем цели
  name = "target-group"

  target {
    subnet_id  = yandex_vpc_subnet.private-zone-e.id
    ip_address = yandex_compute_instance.web-1.network_interface[0].ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.private-zone-d.id
    ip_address = yandex_compute_instance.web-2.network_interface[0].ip_address
  }
}


resource "yandex_alb_backend_group" "backend-group" {   # обработка входящего трафика и проверка здоровья
  name = "backend-group"

  http_backend {
    name             = "web-backend"
    port             = 80
    target_group_ids = [yandex_alb_target_group.target-group.id]

    healthcheck {
      timeout  = "1s"
      interval = "2s"
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "web-router" {  # настройка роутера и маршрутизации
  name = "web-router"
}

resource "yandex_alb_virtual_host" "web-virtual-host" {
  name           = "web-virtual-host"
  http_router_id = yandex_alb_http_router.web-router.id

  route {
    name = "route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-group.id
      }
    }
  }
}

resource "yandex_alb_load_balancer" "web-alb" {  # настройка балансировщика
  name        = "web-alb"
  network_id  = yandex_vpc_network.cloud-net.id
  security_group_ids = [yandex_vpc_security_group.alb-security-group.id]

  allocation_policy {
    location {
      zone_id   = "ru-central1-d"
      subnet_id = yandex_vpc_subnet.public-zone-d.id
    }
  }

  listener {
    name = "web-listener"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web-router.id
      }
    }
  }
}