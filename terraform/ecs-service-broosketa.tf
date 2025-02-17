module "ecs_service_broosketa" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.2.2"

  name        = "broosketa"
  cluster_arn = module.ecs_cluster_broosketa.arn

  cpu    = 1024
  memory = 4096

  container_definitions = {
    ("broosketa") = {
      essential = true
      cpu       = 512
      memory    = 1024
      image     = module.ecr_broosketa.repository_url

      port_mappings = [
        {
          name          = "broosketa"
          containerPort = 5202
          hostPort      = 5202
          protocol      = "tcp"
        }
      ]

      readonly_root_filesystem  = false
      enable_cloudwatch_logging = false

      log_configuration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/broosketa"
          awslogs-region        = local.region
          awslogs-stream-prefix = "ecs"
        }
      }

      memory_reservation = 100
    }
  }

  load_balancer = {
    service = {
      target_group_arn = element(module.ecs_alb_broosketa.target_group_arns, 0)
      container_name   = "broosketa"
      container_port   = 5202
    }
  }

  subnet_ids = module.vpc.private_subnets

  security_group_rules = {
    alb_ingress = {
      type                     = "ingress"
      from_port                = 5202
      to_port                  = 5202
      protocol                 = "tcp"
      source_security_group_id = module.ecs_alb_sg_broosketa.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_service_discovery_http_namespace" "broosketa" {
  name = "broosketa"
}

output "service_id_broosketa" {
  description = "ARN that identifies the service"
  value       = module.ecs_service_broosketa.id
}

output "service_name_broosketa" {
  description = "Name of the service"
  value       = module.ecs_service_broosketa.name
}

output "service_iam_role_name_broosketa" {
  description = "Service IAM role name"
  value       = module.ecs_service_broosketa.iam_role_name
}

output "service_iam_role_arn_broosketa" {
  description = "Service IAM role ARN"
  value       = module.ecs_service_broosketa.iam_role_arn
}

output "service_iam_role_unique_id_broosketa" {
  description = "Stable and unique string identifying the service IAM role"
  value       = module.ecs_service_broosketa.iam_role_unique_id
}

output "service_container_definitions_broosketa" {
  description = "Container definitions"
  value       = module.ecs_service_broosketa.container_definitions
}

output "service_task_definition_arn_broosketa" {
  description = "Full ARN of the Task Definition (including both `family` and `revision`)"
  value       = module.ecs_service_broosketa.task_definition_arn
}
