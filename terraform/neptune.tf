# data "aws_vpc" "default" {
#   default = true
# }

# data "aws_subnet_ids" "default_subnets" {
#   vpc_id = data.aws_vpc.default.id
# }

# resource "aws_neptune_subnet_group" "neptune_subnet_group" {
#   name       = "neptune-subnet-group"
#   subnet_ids = data.aws_subnet_ids.default_subnets.ids
# }

# resource "aws_neptune_cluster_parameter_group" "neptune_cluster_pg" {
#   name        = "neptune-cluster-parameter-group"
#   family      = "neptune1.3"
#   description = "Neptune cluster parameter group"

#   parameter {
#     name         = "neptune_enable_audit_log"
#     value        = "1"
#     apply_method = "pending-reboot"
#   }
# }

# resource "aws_neptune_parameter_group" "neptune_instance_pg" {
#   name        = "neptune-instance-parameter-group"
#   family      = "neptune1.3"
#   description = "Neptune instance parameter group"
# }

# resource "aws_security_group" "neptune_security_group" {
#   name        = "neptune-security-group"
#   description = "Allow access to Neptune from Lambda"
#   vpc_id      = data.aws_vpc.default.id

#   ingress {
#     from_port   = 8182
#     to_port     = 8182
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_neptune_cluster" "neptune_cluster" {
#   cluster_identifier                   = "movie-recommendation-neptune-cluster"
#   engine                               = "neptune"
#   iam_database_authentication_enabled  = true
#   apply_immediately                    = true
#   vpc_security_group_ids               = [aws_security_group.neptune_security_group.id]
#   neptune_subnet_group_name            = aws_neptune_subnet_group.neptune_subnet_group.name
#   neptune_cluster_parameter_group_name = aws_neptune_cluster_parameter_group.neptune_cluster_pg.name
#   skip_final_snapshot                  = true

#   depends_on = [
#     aws_neptune_cluster_parameter_group.neptune_cluster_pg,
#     aws_neptune_subnet_group.neptune_subnet_group
#   ]
# }

# resource "aws_neptune_cluster_instance" "neptune_instance" {
#   count                        = 1
#   identifier                   = "neptune-instance"
#   instance_class               = "db.t3.medium"
#   cluster_identifier           = aws_neptune_cluster.neptune_cluster.id
#   apply_immediately            = true
#   neptune_parameter_group_name = aws_neptune_parameter_group.neptune_instance_pg.name

#   depends_on = [
#     aws_neptune_parameter_group.neptune_instance_pg
#   ]
# }
