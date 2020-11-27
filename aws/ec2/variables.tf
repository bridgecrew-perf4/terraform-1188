variable "region" {
    type        = string
    description = "Region where ec2 instance will be provisioned"
    default     = "us-east-1"
}

variable "instance_count" {
    type        = number
    description = "How many instances will be provisioned"
    default     = 1
}

variable "hostname" {
    type        = string
    description = "Name of ec2 resource"
    default     = ""
}

variable "tags" {
    type        = map(string)
    description = "(optional) tags to assosiate with current resources"
    default     = {}
}

variable "ami" {
    type        = string
    description = "ID of OS image in AWS"
}

variable "instance_type" {
    type        = string
    description = "Type/Size of ec2 instance"
}

variable "key_name" {
    type        = string
    description = "Name of shared ssh key to connect to VM"
    default     = "root"
}

variable "monitoring" {
    type        = bool
    description = "Enabled/Disabled AWS built-in monitoring"
    default     = true
}

variable "vpc_security_group_ids" {
    type        = list(string)
    description ="A list of security group IDs to associate with"
}

variable "subnet_id" {
    type        = string
    description = "Id of subnet where ec2 will be plugged in"
}

variable "ebs_block_device" {
    type        = list(string)
    description = "Additional EBS block devices to attach to the instance"
    default     = []
}
