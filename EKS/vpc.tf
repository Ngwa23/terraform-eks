#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "ngwa" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "terraform-eks-ngwa-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_subnet" "ngwa" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.ngwa.id

  tags = map(
    "Name", "terraform-eks-ngwa-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_internet_gateway" "ngwa" {
  vpc_id = aws_vpc.ngwa.id

  tags = {
    Name = "terraform-eks-ngwa"
  }
}

resource "aws_route_table" "ngwa" {
  vpc_id = aws_vpc.ngwa.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ngwa.id
  }
}

resource "aws_route_table_association" "ngwa" {
  count = 2

  subnet_id      = aws_subnet.ngwa.*.id[count.index]
  route_table_id = aws_route_table.ngwa.id
}
