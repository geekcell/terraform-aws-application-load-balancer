module "vpc" {
  source  = "registry.terraform.io/terraform-aws-modules/vpc/aws"
  version = "~> 3.19"

  name           = "main"
  cidr           = "10.100.0.0/16"
  azs            = ["eu-central-1a", "eu-central-1b"]
  public_subnets = ["10.100.10.0/24", "10.100.11.0/24"]
}

module "basic-example" {
  source = "../../"

  name    = "my-lb"
  subnets = module.vpc.public_subnets

  enable_security_group_default_http_https_rule = true
}
