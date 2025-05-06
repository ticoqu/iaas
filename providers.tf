terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://200.9.165.132:8006/api2/json"
    pm_api_token_id = "terraform@pve!terra"
    pm_api_token_secret = "69622fcf-f422-4551-8fd1-3214a1cd7844"
}
