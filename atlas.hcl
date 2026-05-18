env "local" {
  # Tells Atlas where to find your desired state design
  src = "file://schema.hcl"

  # An isolated, clean Docker image Atlas uses to spin up, 
  # simulate, and safely calculate structural changes
  dev = "docker://postgres/15/dev"

  # Points Atlas to your migrations directory
  migration {
    dir = "file://migrations"
  }
}
