resource "proxmox_vm_qemu" "cluster_psql" {
  for_each = {
    for index, vm in var.cluster_psql :
    vm.name => vm
  }

  name        = each.value.name
  desc        = "Servidores cluster psql"
  clone       = "debian-12-qcow2-template"
  
  # Asignación de recursos según el tipo de servidor (master o worker)
  cores       = each.value.type == "worker" ? 4 : 2
  sockets     = 1
  memory      = each.value.type == "worker" ? 4096 : 2048
  scsihw      = "virtio-scsi-pci"
  agent       = 1
  qemu_os     = "l26"
  ciuser      = "automatizacion"
  cipassword  = "$.mOauY9Wcf0"
  searchdomain = "agetic.gob.bo"
  nameserver  = "8.8.8.8"
  sshkeys     = file("./keys/automatizacion.pub")
  ipconfig0   = "ip=${each.value.ip}/24,gw=192.168.1.1"
  boot = "order=virtio0"
  target_node = each.value.target

  # Discos - Diferenciar entre masters (1 disco) y workers (2 discos)
  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "vol1"
        }
      }
    }

    virtio {
      # Disco principal para ambos (master y worker)
      virtio0 {
        disk {
          storage = "vol1"
          size    = "8G"
        }
      }

      # Solo agregar un segundo disco si es un worker
    dynamic "virtio1" {
        for_each = each.value.type == "worker" ? [1] : []
        content {
          disk {
            storage = "mivol1"
            size    = "2G"
          }
        }
      }
    }
  }

  # Red
  network {
    model  = "virtio"
    bridge = "vmbr0"
    mtu    = 0
  }
}
