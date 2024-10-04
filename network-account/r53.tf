# Create private zone
resource "aws_route53_zone" "private" {
  name = "example.com"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

# Create SG for outbound resolver
resource "aws_security_group" "outbound_resolver" {
  name        = "outbound_resolver"
  description = "SG for outbound resolver"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_dns" {
  security_group_id = aws_security_group.outbound_resolver.id
  cidr_ipv4         = module.vpc.vpc_cidr_block
  from_port         = 53
  ip_protocol       = "udp"
  to_port           = 53
}

resource "aws_vpc_security_group_egress_rule" "allow_dns" {
  security_group_id = aws_security_group.outbound_resolver.id
  cidr_ipv4         = module.vpc.vpc_cidr_block
  from_port         = 1025
  ip_protocol       = "udp"
  to_port           = 65535
}

# Create outbound endpoint
resource "aws_route53_resolver_endpoint" "test" {
  name      = "test"
  direction = "OUTBOUND"
  security_group_ids = [
    aws_security_group.outbound_resolver.id
  ]
  dynamic "ip_address" {

    for_each = module.vpc.subnets
    content {
      subnet_id = ip_address.value.id
    }
  }
  resolver_endpoint_type = "IPV4"
}

# Create resolver rule
resource "aws_route53_resolver_rule" "test" {
  domain_name          = "test.com"
  name                 = "test"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.test.id

  target_ip {
    ip = "8.8.8.8" # Just target Google for testing
  }
}

# Create Rout 53 profile
resource "awscc_route53profiles_profile" "test" {
  name = "test"
}

# Associate private zone with profile
resource "awscc_route53profiles_profile_resource_association" "zone" {
  profile_id   = awscc_route53profiles_profile.test.id
  name         = "zone"
  resource_arn = aws_route53_zone.private.arn
}

# Associate resolver rule with profile
resource "awscc_route53profiles_profile_resource_association" "rule" {
  profile_id   = awscc_route53profiles_profile.test.id
  name         = "rule"
  resource_arn = aws_route53_resolver_rule.test.arn
}

# Create RAM share
resource "aws_ram_resource_share" "profile" {
  name                      = "profile"
  allow_external_principals = false
}

# Associate target account with RAM share
resource "aws_ram_principal_association" "vended1" {
  principal          = "207567787351"
  resource_share_arn = aws_ram_resource_share.profile.arn
}

# Associate profile with RAM share
resource "aws_ram_resource_association" "profile" {
  resource_arn       = awscc_route53profiles_profile.test.arn
  resource_share_arn = aws_ram_resource_share.profile.arn
}

# Test record
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "test"
  type    = "A"
  ttl     = 300
  records = ["10.10.10.66"]
}