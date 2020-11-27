variable "name" {
  type        = string
  description = "Name of EFS system"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be assosiated with resource"
  default = {}
}

variable "mount_subnets" {
  type        = list(string)
  description = "Mount subnets"
  default     = [] 
}

variable "vpc_id" {
  type        = string
  description = "ID of VPC"
  default     = ""
} 

variable "ingress_cidr_blocks" {
  type        = list(string)
  description = ""
  default     = []
} 

variable "ingress_rules" {
  type        = list(string)
  description = ""
  default     = []
}

variable "efs_access_points" {
  type = list(
    object({
      root_directory = object({
        path = string,
        creation_info = object({
          owner_gid = string,
          owner_uid = string,
          permissions = string
        })
      }),
      posix_user = object({
        gid = string,
        uid = string,
        secondary_gids = list(string)
      })
    })
  )

  default = []
}
