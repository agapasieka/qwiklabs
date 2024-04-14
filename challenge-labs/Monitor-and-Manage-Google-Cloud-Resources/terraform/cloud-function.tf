resource "google_cloudfunctions_function" "function" {
  name        = var.function
   runtime     = "nodejs14"
entry_point = "thumbnail"

trigger_bucket = google_storage_bucket.bucket.id




}
