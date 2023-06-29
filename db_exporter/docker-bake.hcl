group "default" {
  targets = ["db-base", "db-exporter"]
}

target "db-base" {
  dockerfile = "../db/Dockerfile"
}

target "db-exporter" {
  contexts = {
    base = "target:db-base"
  }
  dockerfile = "Dockerfile"
  tags = ["blockscout-db-exporter"]
}
