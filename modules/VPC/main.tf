resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr}"
  tags       = "${merge(var.tags, map("Name", format("%s-VPC", var.name)))}"
}
resource "aws_eip" "eip_nat" {
  count = "1"
  vpc   = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = "${merge(var.tags, map("Name", format("%s-igw", var.name)))}"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id     = "${aws_eip.eip_nat.id}"
  subnet_id  = "${element(aws_subnet.public.*.id, 1)}"

  depends_on = ["aws_internet_gateway.igw"]
}
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags       = "${merge(var.tags, map("Name", format("%s-public-route", var.name)))}"
}

resource "aws_default_route_table" "private" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"
  tags                   = "${merge(var.tags, map("Name", format("%s-private-route", var.name)))}"
}

resource "aws_route" "private_nat" {
  route_table_id         = "${aws_default_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat_gw.id}"
}

# AWS Subnet creation

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.public_subnets)}"
  cidr_block              = "${var.public_subnets[count.index]}"
  availability_zone       = "${element(var.availability_zone, count.index)}"
  tags                    = "${merge(var.tags, map("Name", format("%s-public-subnet-%s", var.name, element(var.availability_zone, count.index))))}"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.private_subnets)}"
  cidr_block              = "${var.private_subnets[count.index]}"
  availability_zone       = "${element(var.availability_zone, count.index)}"
  tags                    = "${merge(var.tags, map("Name", format("%s-private-subnet-%s", var.name, element(var.availability_zone, count.index))))}"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "rds" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.rds_subnets)}"
  cidr_block              = "${var.rds_subnets[count.index]}"
  availability_zone       = "${element(var.availability_zone, count.index)}"
  tags                    = "${merge(var.tags, map("Name", format("%s-RDS-subnet-%s", var.name, element(var.availability_zone, count.index))))}"
  map_public_ip_on_launch = false
}

# VPC Subnets association

resource "aws_route_table_association" "public_assoc" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private_assoc" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_default_route_table.private.*.id, count.index)}"
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name          = "rds_subnet_group"
  #subnet_ids    = ["${element(split(",", aws_subnet.rds.*.id), count.index)}"]
  subnet_ids    = ["${aws_subnet.rds.*.id}"]
  tags          = "${merge(var.tags, map("Name", format("%s-rds-subnet", var.name)))}"
}

# VPC Security group resources

resource "aws_security_group" "public" {
  name          = "SG_Public"
  description   = "For public inbound access"
  vpc_id        = "${aws_vpc.vpc.id}"

  #SSH access
  ingress {
    from_port    = 22
    to_port      = 22
    protocol     = "tcp"
    cidr_blocks  = ["${var.allowed_ip}"]
  }

  #HTTP access
  ingress {
    from_port    = 80
    to_port      = 80
    protocol     = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  # Outbound Internet access
  egress {
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private" {
  name          = "SG_Private"
  description   = "For private instances"
  vpc_id        = "${aws_vpc.vpc.id}"

  ingress {
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["${var.cidr}"]
  }

  egress {
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
}

# RDS Security groups
resource "aws_security_group" "RDS" {
  name          = "SG_RDS"
  description   = "For RDS instances"
  vpc_id        = "${aws_vpc.vpc.id}"

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.public.id}", "${aws_security_group.private.id}"]
  }

  egress {
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
}
