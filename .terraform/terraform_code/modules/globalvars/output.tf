# Default tags
output "default_tags" {
  value = merge(
    {
      "Owner"   = "Dockerintro"
      "App"     = "Web"
      "Project" = "CLO835"
    },
    {
      "Env" = var.env
    }
  )
}

# Prefix to identify resources
output "prefix" {
  value = local.name_prefix
}
