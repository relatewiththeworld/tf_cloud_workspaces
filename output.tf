output "vpc_id" {
    value =  aws_internet_gateway.tf_igw.id #resource type . resource name
}

output "instance_public_ip" {
    value = aws_instance.tf_instance.public_ip
}