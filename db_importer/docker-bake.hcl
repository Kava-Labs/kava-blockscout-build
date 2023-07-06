group "default" {
  targets = ["db-base", "db-importer"]
}

target "db-base" {
  dockerfile = "../db/Dockerfile"
}

target "db-importer" {
  contexts = {
    base = "target:db-base"
  }
  dockerfile = "Dockerfile"
  tags = ["blockscout-db-importer"]
}
