module "vpc" {
  source          = "../../network-terraform-aws-modules/vpc"
  name_prefix     = "vended2"
  max_zones       = 2
  ipv4_cidr_block = "10.0.2.0/24"
  networks = [{
    name    = "subnet-1"
    netmask = 25
  }]
}