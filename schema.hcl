schema "public" {}

table "users" {
  schema = schema.public

  column "id" {
    type = serial
  }

  column "name" {
    type = varchar(255)
  }

  column "email" {
    type = varchar(255)
    null = true
  }

  primary_key {
    columns = [column.id]
  }
}
