variable "cluster_psql" {
  type = list(object({
    name   = string
    ip     = string
    target = string
    type   = string
  }))
}
