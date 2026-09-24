resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.enterprise_stock_system}-vpc"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name        = "${var.enterprise_stock_system}-igw"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each = zipmap(
    var.availability_zones,
    var.public_subnet_cidrs
  )

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.enterprise_stock_system}-public-${each.key}"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Type        = "Public"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name        = "${var.enterprise_stock_system}-public-rt"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

resource "aws_route_table_association" "public_rt_assoc" {
  for_each = aws_subnet.public_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_subnet" "private_subnet" {
  for_each = zipmap(
    var.availability_zones,
    var.private_subnet_cidrs
  )

  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name        = "${var.enterprise_stock_system}-private-${each.key}"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Type        = "Private"
  }
}

#two private rt table for two NAT gtw 
resource "aws_route_table" "private_rt" {
  for_each = toset(var.availability_zones)

  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name        = "${var.enterprise_stock_system}-private-rt-${each.key}"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Type        = "Private"
  }
}

resource "aws_route_table_association" "private_rt_assoc" {
  for_each = aws_subnet.private_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt[each.key].id
}

resource "aws_route" "private_nat" {
  for_each = toset(var.availability_zones)

  route_table_id         = aws_route_table.private_rt[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[each.key].id
}


resource "aws_eip" "nat_eip" {
  for_each = toset(var.availability_zones)

  domain = "vpc"

  tags = {
    Name        = "${var.enterprise_stock_system}-nat-eip-${each.key}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


resource "aws_nat_gateway" "nat" {
  for_each = toset(var.availability_zones)

  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.public_subnet[each.key].id

  tags = {
    Name        = "${var.enterprise_stock_system}-nat-${each.key}"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Type        = "NAT"
  }

  depends_on = [
    aws_internet_gateway.main_igw
  ]
}