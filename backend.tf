terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    region  = "eu-west-2"
    profile = "default"
    key     = "deploy_iac_tf_ansible"
    bucket  = "tf-chin-state-bucket"
  }
}
