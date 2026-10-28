
resource "yandex_vpc_security_group" "bastion-security-group" {
  name       = "bastion-security-group"
  network_id = yandex_vpc_network.cloud-net.id

  ingress {
    protocol       = "TCP"         #cнаружи можно подключаться по SSH с любых IP-адресов по 22 порту
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"   #исходящий трафик по любому протоколу куда угодно
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "web-security-group" {
  name       = "web-security-group"
  network_id = yandex_vpc_network.cloud-net.id

  ingress {
    protocol          = "TCP"   # снаружи можно подключаться по TCP :80 только от балансировщика alb
    port              = 80
    security_group_id = yandex_vpc_security_group.alb-security-group.id
  }

  ingress {
    protocol          = "TCP"   # снаружи можно подключаться по TCP :80  от healthcheck
    port              = 80
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
  }

  ingress {
    protocol          = "TCP"  # входящий трафик по протоколу TCP порт22 (SSH) от бастиона
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion-security-group.id
  }

  ingress {
    protocol          = "TCP"  # входящий трафик по протоколу TCP порт22 (SSH) от кибана
    port              = 22
    security_group_id = yandex_vpc_security_group.kibana-security-group.id
  }

  ingress {
    protocol          = "TCP"  # входящий трафик по протоколу TCP порт 10050  от zabbix
    port              = 10050
    security_group_id = yandex_vpc_security_group.zabbix-security-group.id
  }

   ingress {
    protocol          = "TCP"  # входящий трафик по протоколу TCP порт 80  от zabbix
    port              = 80
    security_group_id = yandex_vpc_security_group.zabbix-security-group.id
  }


  egress {
    protocol       = "ANY"   # исходящий трафик по любому протоколу куда угодно
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "zabbix-security-group" {
  name       = "zabbix-security-group"
  network_id = yandex_vpc_network.cloud-net.id

  ingress {
    protocol       = "TCP"  # снаружи можно подключаться по TCP :80 со всех ip-адресов
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    protocol       = "TCP"  # входящий трафик по TCP :8080 для веб-интерфейса Zabbix
    port           = 8080
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol          = "TCP"  # снаружи можно подключаться по TCP :22 (SSH) только от бастиона
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion-security-group.id
  }

  ingress {
    protocol          = "TCP"   # входящий трафик по протоколу TCP порт 10051  от веб-серверов
    port              = 10051
    v4_cidr_blocks = ["10.10.2.0/24", "10.10.3.0/24","10.10.5.0/24"]
  }

  egress { 
    protocol       = "ANY"   # исходящий трафик по любому протоколу куда угодно
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "elasticsearch-security-group" {
  name       = "elasticsearch-security-group"
  network_id = yandex_vpc_network.cloud-net.id

  ingress {
    protocol          = "TCP"  # входящий трафик по TCP :9200 от kibana
    port              = 9200
    security_group_id = yandex_vpc_security_group.kibana-security-group.id
  }

  ingress {
    protocol          = "TCP" # входящий трафик по TCP :9200 от веб-серверов
    port              = 9200  
    security_group_id = yandex_vpc_security_group.web-security-group.id
  }

  ingress {
    protocol          = "TCP"  # входящий трафик по TCP :22 от бастиона
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion-security-group.id
  }

  ingress {
    protocol          = "TCP"  # входящий трафик по TCP :22 от кибана
    port              = 22
    security_group_id = yandex_vpc_security_group.kibana-security-group.id
  }

  egress {
    protocol       = "ANY"   # исходящий трафик по любому протоколу куда угодно
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "yandex_vpc_security_group" "kibana-security-group" {
  name       = "kibana-security-group"
  network_id = yandex_vpc_network.cloud-net.id

  ingress {
    protocol       = "TCP"  # входящий трафик по TCP :5601 с любых ip-адресов
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol          = "TCP"  # входящий трафик по TCP :22 (SSH) от бастиона
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion-security-group.id
  }
  ingress {
    description    = "SSH from my IP for temporary access"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["178.207.165.90/32"]
  }
  egress {
    protocol       = "ANY"   # исходящий трафик по любому протоколу куда угодно
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "alb-security-group" {
  name       = "alb-security-group"
  network_id = yandex_vpc_network.cloud-net.id

  ingress {
    protocol       = "TCP"   # входящий трафик по TCP :80 с любых ip-адресов
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"  # входящий трафик по TCP :30080 c ip-адресов yandex cloud для проверок
    port           = 30080
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
  }

  egress {
    protocol       = "ANY"   # исходящий трафик по любому протоколу куда угодно
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}