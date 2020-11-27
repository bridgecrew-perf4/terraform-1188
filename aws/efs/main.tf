resource "aws_efs_file_system" "main" {
  creation_token = var.name
  tags           = var.tags
}

resource "aws_security_group" "main" {
    name = var.name
    description = "SG create by terraform for EFS cluster - ${var.name}"
    vpc_id = var.vpc_id

    ingress_cidr_blocks = var.ingress_cidr_blocks
    ingress_rules       = var.ingress_rules

    tags = var.tags
}

resource "aws_efs_mount_target" "main" {
  count = length(var.mount_subnets)
  file_system_id = aws_efs_file_system.main.id
  subnet_id = element(var.mount_subnets, count.index)
  security_groups = aws_security_group.main.id

  tags = var.tags
}

resource "aws_efs_access_point" "main" {
  count = length(var.efs_access_points)
  file_system_id = aws_efs_file_system.main.id

  dynamic "root_directory" {
      for_each = [var.efs_access_points[count.index].root_directory]
      content {
          path = root_directory.value["path"]
          creation_info {
            owner_gid   = root_directory.value["creation_info"]["owner_gid"]
            owner_uid   = root_directory.value["creation_info"]["owner_uid"]
            permissions = root_directory.value["creation_info"]["permissions"]
          }
      }
  }
  
  dynamic "posix_user" {
      for_each = [var.efs_access_points[count.index].posix_user]
      content {
          gid            = posix_user.value["gid"]
          uid            = posix_user.value["uid"]
          secondary_gids = posix_user.value["secondary_gids"]
        }
    }
  tags = var.tags
}
