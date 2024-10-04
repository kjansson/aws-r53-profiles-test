# Does not work, needs custom RAM share policy
# data awscc_route53profiles_profile "profile" {
#     id = "rp-f37bdeed65e0448c"
# }

# Associate target VPC with profile
# resource "awscc_route53profiles_profile_association" "vpc" {
#     name = "vpc"
#     resource_id = module.vpc.vpc_id
#     profile_id = "rp-f37bdeed65e0448c" # Hardcoded since data lookup doesn't work
# }