provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_version = "1.8.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.24.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.24.0"
    }
  }
}