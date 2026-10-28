resource "yandex_compute_snapshot_schedule" "daily-snapshots" {
  name = "daily-snapshots"

  # Расписание: каждый день в 02:00 ночи (UTC)
  schedule_policy {
    expression = "0 0 ? * *" 
  }

  retention_period = "168h" 
  
  disk_ids = [
    yandex_compute_instance.bastion.boot_disk[0].disk_id,
    yandex_compute_instance.web-1.boot_disk[0].disk_id,
    yandex_compute_instance.web-2.boot_disk[0].disk_id,
    yandex_compute_instance.zabbix.boot_disk[0].disk_id,
    yandex_compute_instance.kibana.boot_disk[0].disk_id,
    yandex_compute_instance.elasticsearch.boot_disk[0].disk_id,
  ]
}