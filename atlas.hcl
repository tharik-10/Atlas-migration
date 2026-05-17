env "dev" {
  url = "docker://postgres/16/dev"

  migration {
    dir = "file://migrations"
  }
}

env "local" {
  url = "postgres://postgres:postgres@localhost:5432/testdb?sslmode=disable"

  migration {
    dir = "file://migrations"
  }
}
