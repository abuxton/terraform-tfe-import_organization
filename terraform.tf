terraform {
  required_version = "~>1.8"
  required_providers {
    tfe = {
      version = "~> 0.55.0"
    }
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "1.2.1"
    }
  }
}
provider "tfe" {
}
provider "terracurl" {
}
