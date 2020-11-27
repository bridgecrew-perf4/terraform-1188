provider "aws {
    region = var.region
}

resource "aws_instance" "main" {
    count                   = var.instance_count
    name                    = var.hostname
    ami                     = var.ami
    instance_type           = var.instance_type
    key_name                = var.key_name
    monitoring              = var.monitoring
    vpc_security_group_ids  = var.vpc_security_group_ids
    subnet_id               = var.subnet_id
    ebs_block_device        = var.ebs_block_device

    tags = var.tags
}
