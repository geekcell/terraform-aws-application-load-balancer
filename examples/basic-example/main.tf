module "basic-example" {
  source = "../../"

  name    = "my-lb"
  subnets = ["subnet-123", "subnet-456", "subnet-789"]
}
