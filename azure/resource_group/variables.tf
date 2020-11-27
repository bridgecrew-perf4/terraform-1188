variable "name" {
    type        = string
    description = "Name of resource group to be created" 
}

variable "region" {
    type        = string
    description = "Region where resource group will be assosiated"
}

variable "tags" {
    type        = map(string)
    description = "(optional) Tags to assosiate with RG"
    default     = {}
}
