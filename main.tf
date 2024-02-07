provider "aws" {
    profile = "default"
    region = "us-east-1"
}

# ressources
resource "aws_instance" "web_server" {
    ami = "ami-094aa6728b151e05a"
    instance_type = "t2.small"
    tags = {
        Name = "EVUWin"
    }
}

resource "aws_vpc" "evu_vpc" {
  cidr_block = "10.0.0.0/32"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.evu_vpc.id
  cidr_block = "10.0.0.0/25"
  map_public_ip_on_launch = true # Change to false if you don't want public IPs
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.evu_vpc.id
  cidr_block = "10.0.0.125/25"
  map_public_ip_on_launch = false # Change to false if you don't want public IPs
}

resource "aws_internet_gateway" "evu_gw" {
  vpc_id = aws_vpc.evu_vpc.id
}


resource "aws_route_table" "evu_private_routetable" {
  vpc_id = aws_vpc.evu_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.evu_nat_gateway.id
  }
}


resource "aws_route_table" "evu_public_routetable" {
  vpc_id = aws_vpc.evu_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.evu_igw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.routetable.id
}

resource "aws_nat_gateway" "evu_nat_gateway" {
  allocation_id = "eipalloc-000ff748fdce8d830"  # Example EIP allocation ID for the NAT Gateway
  subnet_id     = aws_subnet.evu_public_subnet.id  # The subnet ID where the NAT Gateway resides (must be a public subnet)
  tags = {
    Name = "evu_nat_gateway"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.evu_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "windows_instance" {
  ami           = "ami-0c2f25c1f66a1ff4p"  # Change to a Windows 2022 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.allow_all.name]

  tags = {
    Name = "WindowsServer2022"
  }
}

resource "aws_instance" "ubuntu_instance_1" {
  ami           = "ami-05c424d59413a2876"  # Change to an Ubuntu AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.allow_all.name]

  tags = {
    Name = "UbuntuMongoDB"
  }
}

resource "aws_instance" "ubuntu_instance_2" {
  ami           = "ami-05c424d59413a2876"  # Change to an Ubuntu AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.allow_all.name]

  tags = {
    Name = "UbuntuNginx"
  }
}