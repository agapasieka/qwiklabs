resource "google_cloudfunctions_function" "function" {
  name        = var.function
  runtime     = "nodejs14"
  entry_point = "thumbnail"

  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = google_storage_bucket.bucket.name
  }
}
