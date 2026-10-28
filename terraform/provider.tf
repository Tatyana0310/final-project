terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  cloud_id  = "b1g75pmh7g47a76mmoqs"
  folder_id = "b1ghnqv6na3vjnp9qu69"
  zone      = "ru-central1-a"
}