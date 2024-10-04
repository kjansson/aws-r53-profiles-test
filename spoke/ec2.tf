module "test_instance" {
    source = "../../network-terraform-aws-modules/instance"
    name_prefix = "test"
    subnet_id = module.vpc.subnets["subnet-1-eun1-az1"].id
    vpc_id = module.vpc.vpc_id
}

module "session_manager" {
    source = "../../network-terraform-aws-modules/session-manager"
    name_prefix = "test"
    subnet_ids = [module.vpc.subnets["subnet-1-eun1-az1"].id]
    vpc_id = module.vpc.vpc_id
    vpc_cidr_block = module.vpc.vpc_cidr_block
}