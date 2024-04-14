resource "google_storage_bucket" "bucket" {
  name          = var.bucket
  location      = var.region
  force_destroy = true

  public_access_prevention = "enforced"
}