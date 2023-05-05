output "vpc_name" {
  description = "VPC Name"
  value       = aws_vpc.my_generic_vpc.tags["Name"]
}
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.my_generic_vpc.id
}
output "instance_name" {
  description = "Instance name"
  value       = aws_instance.generic_instance.tags["Name"]
}
output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.generic_instance.id
}
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.generic_instance.public_ip
}
