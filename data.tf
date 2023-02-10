data "aws_subnet" "main" {
  id = element(var.subnets, 0)
}
