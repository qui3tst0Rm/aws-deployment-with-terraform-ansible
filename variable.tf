variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "eu-west-1"
}

variable "region-worker" {
  type    = string
  default = "eu-west-2"
}

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "workers-count" {
  type    = number
  default = 1
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
}

/*variable "private_key" {
  #default = "./key_pair/id_rsa"
  default = "/Users/chin/Projects/Cloud-Engineer-Projects/Ansible/deploy_iac_tf_ansible/key_pair/id_rsa"
}*/

variable "ssh-user" {
  type    = string
  default = "ec2-user"
}
