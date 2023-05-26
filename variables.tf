## NAMING
variable "name" {
  description = "Name or prefix of the Role."
  type        = string
}

variable "tags" {
  description = "Tags to add to the Role."
  default     = {}
  type        = map(any)
}

## AWS Application Load Balancer
variable "access_logs_bucket_id" {
  default     = ""
  description = "The S3 bucket name to store the logs in."
  type        = string
}

variable "customer_owned_ipv4_pool" {
  default     = null
  description = "The ID of the customer owned ipv4 pool to use for this load balancer."
  type        = string
}

variable "desync_mitigation_mode" {
  default     = "strictest"
  description = "Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync."
  type        = string
}

variable "drop_invalid_header_fields" {
  default     = false
  description = " Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false)."
  type        = bool
}

variable "enable_cross_zone_load_balancing" {
  default     = false
  description = " If true, cross-zone load balancing of the load balancer will be enabled."
  type        = bool
}

variable "enable_deletion_protection" {
  default     = true
  description = "If true, deletion of the load balancer will be disabled via the AWS API."
  type        = bool
}

variable "enable_http2" {
  default     = true
  description = "Indicates whether HTTP/2 is enabled in application load balancers."
  type        = bool
}

variable "enable_waf_fail_open" {
  default     = false
  description = "Indicates whether to allow a WAF-enabled load balancer to route requests to targets if it is unable to forward the request to AWS WAF."
  type        = bool
}

variable "idle_timeout" {
  default     = 60
  description = "The time in seconds that the connection is allowed to be idle."
  type        = number
}

variable "internal" {
  default     = false
  description = "If true, the LB will be internal."
  type        = bool
}

variable "ip_address_type" {
  default     = "ipv4"
  description = "The type of IP addresses used by the subnets for your load balancer."
  type        = string
}

variable "preserve_host_header" {
  default     = false
  description = "Indicates whether the Application Load Balancer should preserve the Host header in the HTTP request and send it to the target without any change."
  type        = bool
}

variable "security_groups" {
  default     = []
  description = "A list of security group IDs to assign to the LB."
  type        = list(string)
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the LB."
  type        = list(string)
}

## AWS Load Balancer Listener
variable "enable_http_to_https_redirect" {
  description = "Whether to create a default HTTP to HTTPS redirect rule."
  default     = true
  type        = bool
}

## AWS Security Groups
variable "enable_security_group" {
  description = "Whether to create a security group for the load balancer."
  default     = true
  type        = bool
}

variable "enable_security_group_default_http_https_rule" {
  description = "Whether to create a default security group rule to allow HTTP and HTTPS traffic from anywhere."
  default     = false
  type        = bool
}
