terraform {
  backend "s3" {
    bucket = "terraform-state-demonstration"
    key    = "development/broosketa"
    region = "us-east-1"
  }
}