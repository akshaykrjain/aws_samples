locals {
  vpc_name = "backend_prod"
}

locals {
  network_config = yamldecode(file("network.yaml"))["global"]["aws"]
}

locals {
  vpcs = flatten(local.network_config["vpcs"])
}

output "vpc_cidr" {
  value = [for vpc in local.vpcs : vpc.vpc_cidr if vpc.vpc_name == local.vpc_name][0]
}

output "private_subnet_cidrs" {
  value = tolist([for vpc in local.vpcs : vpc.private_subnet_cidrs if vpc.vpc_name == local.vpc_name])
}

output "public_subnet_cidrs" {
  value = tolist([for vpc in local.vpcs : vpc.public_subnet_cidrs if vpc.vpc_name == local.vpc_name])
}