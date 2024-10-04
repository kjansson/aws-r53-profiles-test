module "vpc" {
    source = "../../network-terraform-aws-modules/vpc"
    name_prefix = "vended1"
    max_zones = 1
    ipv4_cidr_block = "10.0.1.0/24"
    networks = [ {
        name = "subnet-1"
        netmask = 25
    } ]
}