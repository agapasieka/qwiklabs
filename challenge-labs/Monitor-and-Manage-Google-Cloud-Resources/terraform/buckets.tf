resource "google_storage_bucket" "cf_bucket" {
  name          = var.cf-bucket
  location      = var.region
  force_destroy = true

  public_access_prevention = "enforced"
}

resource "google_storage_bucket" "input_bucket" {
  name          = var.input-bucket
  location      = var.region
  force_destroy = true

  public_access_prevention = "enforced"
}
