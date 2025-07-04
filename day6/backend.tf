terraform {
    backend "s3" {
        bucket         = "terraformtfstatebucket0023"
        key            = "terraform.tfstate"
        region         = "us-east-2"
  }
}