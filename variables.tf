variable "region" {
    type = string
    default = "eu-central-1"
}

variable "access_key" {
    type = string
    sensitive = true
}

variable "secret_key" {
    type = string
    sensitive = true
}

variable "vpc_cidr" {
    type = string
}

variable "vpc_name" {
    type = string
}

variable "subnet_cidr" {
    type = string
}

variable "subnet_name" {
    type = string
}

variable "rt_name" {
    type = string
}

variable "ami" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "key_name" {
    type = string
}

variable "instance_name" {
    type = string
}