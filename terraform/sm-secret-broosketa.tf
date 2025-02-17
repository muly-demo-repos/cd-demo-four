resource "random_password" "broosketa_secret_password" {
  length  = 20
  special = false
}

resource "aws_secretsmanager_secret" "secrets_broosketa" {
  name = "broosketa_secrets"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_secretsmanager_secret_version" "secrets_version_broosketa" {
  secret_id     = aws_secretsmanager_secret.secrets_broosketa.id
  secret_string = jsonencode({
    BCRYPT_SALT       = "10"
    JWT_EXPIRATION    = "2d"
    JWT_SECRET_KEY    = random_password.broosketa_secret_password.result
    DB_URL            = "postgres://${module.rds_broosketa.db_instance_username}:${random_password.broosketa_database_password.result}@${module.rds_broosketa.db_instance_address}:5432/${module.rds_broosketa.db_instance_name}"
  })
}
