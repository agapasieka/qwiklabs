# Generates an archive of the source code compressed as a .zip file.
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "cf_config"
  output_path = "${path.module}/cf_config/function.zip"
}

# Add source code zip to the Cloud Function's bucket (Cloud_function_bucket) 
resource "google_storage_bucket_object" "zip" {
  source       = data.archive_file.source.output_path
  content_type = "application/zip"
  name         = "src-${data.archive_file.source.output_md5}.zip"
  bucket       = google_storage_bucket.cf_bucket.name
  depends_on = [
    google_storage_bucket.cf_bucket,
    data.archive_file.source
  ]
}


resource "google_cloudfunctions_function" "function" {
  name                  = var.function
  runtime               = "nodejs14"
  entry_point           = "thumbnail"
  source_archive_bucket = google_storage_bucket.cf_bucket.name
  source_archive_object = google_storage_bucket_object.zip.name

  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = google_storage_bucket.input_bucket.name
  }
}

