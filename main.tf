/**
 * # Terraform AWS Application Load Balancer
 *
 * This Terraform module provides a preconfigured solution for setting up an
 * AWS Application Load Balancer in your AWS account. The Application Load
 * Balancer is a highly available and scalable load balancing solution for
 * your applications. With this Terraform module, you can easily and
 * efficiently set up and manage your load balancer, ensuring that your
 * applications are highly available and can handle increasing traffic.
 *
 * Our team has extensive experience working with AWS load balancers and
 * has optimized this module to provide the best possible experience for
 * users. The module encapsulates all necessary configurations, making it
 * easy to use and integrate into your existing AWS environment. Whether you
 * are just getting started with load balancing or looking for a more efficient
 * way to manage your applications, this Terraform module provides a
 * preconfigured solution for high availability and scalability.
 */
resource "aws_lb" "main" {
  customer_owned_ipv4_pool         = var.customer_owned_ipv4_pool
  desync_mitigation_mode           = var.desync_mitigation_mode
  drop_invalid_header_fields       = var.drop_invalid_header_fields
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = var.enable_http2
  enable_waf_fail_open             = var.enable_waf_fail_open
  idle_timeout                     = var.idle_timeout
  internal                         = var.internal
  ip_address_type                  = var.ip_address_type
  load_balancer_type               = "application"
  name                             = var.name
  preserve_host_header             = var.preserve_host_header
  security_groups                  = concat(try([module.sg[0].security_group_id], []), var.security_groups)
  subnets                          = var.subnets

  dynamic "access_logs" {
    for_each = var.access_logs_bucket_id == "" ? [] : [true]

    content {
      bucket  = var.access_logs_bucket_id
      prefix  = ""
      enabled = true
    }
  }

  tags = var.tags
}

resource "aws_lb_listener" "main" {
  count = var.enable_http_to_https_redirect ? 1 : 0

  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = var.tags
}

module "sg" {
  count = var.enable_security_group ? 1 : 0

  source = "github.com/geekcell/terraform-aws-security-group?ref=main"

  vpc_id = data.aws_subnet.main.vpc_id
  name   = "${var.name}-alb"

  ingress_rules = !var.enable_security_group_default_http_https_rule ? [] : [
    {
      protocol    = "tcp"
      port        = 80
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      protocol    = "tcp"
      port        = 443
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = var.tags
}
