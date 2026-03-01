# ---------------------------------------------------------------------------------------------------------------------
# SECURITY GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "this" {
  name        = "${var.name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.enable_http ? [1] : []
    content {
      description = "HTTP from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    for_each = var.enable_https ? [1] : []
    content {
      description = "HTTPS from anywhere"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { "Name" = "${var.name}-alb-sg" },
    var.tags
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# APPLICATION LOAD BALANCER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb" "this" {
  name               = "${var.name}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = concat([aws_security_group.this.id], var.security_groups)
  subnets            = var.subnets

  tags = merge(
    { "Name" = "${var.name}-alb" },
    var.tags
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# TARGET GROUP
# Only created when default_action_type is "forward".
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_target_group" "this" {
  count = var.default_action_type == "forward" ? 1 : 0

  name        = "${var.name}-tg"
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags = merge(
    { "Name" = "${var.name}-tg" },
    var.tags
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# HTTPS LISTENER (PORT 443)
# Only created when enable_https is true. Requires certificate_arn.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_listener" "https" {
  count = var.enable_https ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  dynamic "default_action" {
    for_each = var.default_action_type == "forward" ? [1] : []
    content {
      type             = "forward"
      target_group_arn = aws_lb_target_group.this[0].arn
    }
  }

  dynamic "default_action" {
    for_each = var.default_action_type == "fixed-response" ? [1] : []
    content {
      type = "fixed-response"

      fixed_response {
        content_type = var.fixed_response_content_type
        message_body = var.fixed_response_message_body
        status_code  = var.fixed_response_status_code
      }
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# HTTP LISTENER (PORT 80) - FORWARD TO TARGET GROUP OR FIXED RESPONSE
# Created when enable_http is true AND (HTTPS is disabled OR redirect is disabled).
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_listener" "http" {
  count = var.enable_http && (!var.enable_https || !var.redirect_http_to_https) ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  dynamic "default_action" {
    for_each = var.default_action_type == "forward" ? [1] : []
    content {
      type             = "forward"
      target_group_arn = aws_lb_target_group.this[0].arn
    }
  }

  dynamic "default_action" {
    for_each = var.default_action_type == "fixed-response" ? [1] : []
    content {
      type = "fixed-response"

      fixed_response {
        content_type = var.fixed_response_content_type
        message_body = var.fixed_response_message_body
        status_code  = var.fixed_response_status_code
      }
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# HTTP LISTENER (PORT 80) - REDIRECT TO HTTPS
# Created when both HTTP and HTTPS are enabled and redirect is enabled.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_listener" "http_redirect" {
  count = var.enable_http && var.enable_https && var.redirect_http_to_https ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
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
}

# ---------------------------------------------------------------------------------------------------------------------
# ROUTE53 DNS RECORD (OPTIONAL)
# Only created when create_dns_record is true.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route53_record" "lb_dns" {
  count = var.create_dns_record ? 1 : 0

  zone_id = var.zone_id
  name    = var.domain
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.this.dns_name]
}
