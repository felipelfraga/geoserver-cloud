# resource "aws_appautoscaling_target" "this" {
#   max_capacity       = 2
#   min_capacity       = 1
#   resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

# resource "aws_appautoscaling_policy" "memory" {
#   name               = "memory"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.this.resource_id
#   scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.this.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageMemoryUtilization"
#     }

#     target_value = 60
#   }
# }

# resource "aws_appautoscaling_policy" "cpu" {
#   name               = "cpu"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.this.resource_id
#   scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.this.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }

#     target_value = 60
#   }
# }

