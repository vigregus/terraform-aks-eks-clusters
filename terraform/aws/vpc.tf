data "aws_availability_zones" "available" {}

module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "5.1.2"
  name                   = "${var.prefix}-VPC"
  cidr                   = "10.10.0.0/16"
  azs                    = data.aws_availability_zones.available.names
  private_subnets        = ["10.10.0.0/19", "10.10.32.0/19", "10.10.64.0/19"]
  public_subnets         = ["10.10.96.0/22", "10.10.100.0/22", "10.10.104.0/22"]
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true

  tags = {
    "Name" = "${var.prefix}-VPC"
  }

  public_subnet_tags = {
    "Name"                                        = "${var.prefix}-public-subnet"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "Name"                                        = "${var.prefix}-private-subnet"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }

  public_route_table_tags = {
    "Name" = "${var.prefix}-public-route-table"
  }

  private_route_table_tags = {
    "Name" = "${var.prefix}-private-route-table"
  }
}
