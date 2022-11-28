terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.82.0"
    }
  }
}

provider "yandex" {
  token     = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  cloud_id  = "b1gkfsu9d5sv09gj4t11"
  folder_id = "b1git5hia0rofr17aar8"
}

resource "yandex_mdb_postgresql_cluster" "fialka" {
  name        = "HAwk"
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.sweet_potato.id

  config {
    version = 15
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 16
    }
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }

  host {
    assign_public_ip = true
    zone      = "ru-central1-b"
    subnet_id = yandex_vpc_subnet.potato.id
  }

  host {
    assign_public_ip = true
    zone      = "ru-central1-c"
    subnet_id = yandex_vpc_subnet.batatas.id
  }
}

resource "yandex_vpc_network" "sweet_potato" {}

resource "yandex_vpc_subnet" "potato" {
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.sweet_potato.id
  v4_cidr_blocks = ["10.1.0.0/24"]
}

resource "yandex_vpc_subnet" "batatas" {
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.sweet_potato.id
  v4_cidr_blocks = ["10.2.0.0/24"]
}

resource "yandex_mdb_postgresql_user" "fialka" {
  cluster_id = yandex_mdb_postgresql_cluster.fialka.id
  name       = "gralvic"
  password   = "fialka_password"
  conn_limit = 50
  settings = {
    default_transaction_isolation = "read committed"
    log_min_duration_statement    = 5000
  }
}

resource "yandex_mdb_postgresql_database" "fialka" {
  cluster_id = yandex_mdb_postgresql_cluster.fialka.id
  name       = "database_for_Netology"
  owner      = yandex_mdb_postgresql_user.fialka.name
  lc_collate = "en_US.UTF-8"
  lc_type    = "en_US.UTF-8"
  extension {
    name = "uuid-ossp"
  }
  extension {
    name = "xml2"
  }
}
