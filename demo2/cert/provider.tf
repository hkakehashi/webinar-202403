terraform {
  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = "~> 5.6.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.39.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
