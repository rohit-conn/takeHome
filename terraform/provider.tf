terraform {
  required_version = ">= 1.2.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.46"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}
