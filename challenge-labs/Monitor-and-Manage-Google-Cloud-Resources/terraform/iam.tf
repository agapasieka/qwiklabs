module "project-iam-bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  projects = [var.project_id]
  mode     = "additive"

  bindings = {
    "roles/storage.objectViewer" = [
      "user:${var.user}",
    ]
    "roles/pubsub.publisher" = [
      "serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com",
    ]
      "roles/artifactregistry.reader" = [
      "serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com",
    ]
      "roles/eventarc.eventReceiver" = [
      "serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com",
    ]
  }
}