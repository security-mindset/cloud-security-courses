# Création du bucket S3 pour les logs
resource "aws_s3_bucket" "sm_logs" {
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }
}