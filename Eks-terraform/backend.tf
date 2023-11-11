terraform {
  backend "s3" {
    bucket = "rameshkumarverma1987" # Replace with your actual S3 bucket name
    key    = "EKS/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
