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

  // --- NEW FIELDS ADDED HERE ---
  column "age" {
    type = integer
    null = true
  }

  column "status" {
    type    = varchar(50)
    default = "active"
  }

  column "created_at" {
    type    = timestamptz
    default = sql("CURRENT_TIMESTAMP")
  }
  // -----------------------------

  primary_key {
    columns = [column.id]
  }
}
