# Dynamiczne wyszukiwanie oficjalnego obrazu Amazon Linux 2023 (architektura x86_64)
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Pobranie bramy internetowej (Internet Gateway), która już istnieje w VPC
data "aws_internet_gateway" "existing" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

# Dedykowany subnet dla instancji bridge
resource "aws_subnet" "bridge_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.bridge_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-subnet"
  }
}

# Tabela routingu kierująca ruch zewnętrzny przez Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.existing.id
  }

  tags = {
    Name = "${var.name_prefix}-rt"
  }
}

# Skojarzenie tabeli routingu z podsiecią bridge
resource "aws_route_table_association" "bridge_assoc" {
  subnet_id      = aws_subnet.bridge_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Instancja EC2 pełniąca rolę mostu SSM (Zero-Trust Bridge)
resource "aws_instance" "bridge_ec2" {
  ami                  = data.aws_ami.amazon_linux_2023.id
  instance_type        = var.instance_type
  subnet_id            = aws_subnet.bridge_subnet.id
  iam_instance_profile = aws_iam_instance_profile.bridge_profile.name

  vpc_security_group_ids = [aws_security_group.bridge_sg.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  # Opcjonalny skrypt bootstrapu (klient bazy danych dla sesji SSM)
  user_data = fileexists("${path.module}/user_data.sh") ? file("${path.module}/user_data.sh") : null

  tags = {
    Name = "${var.name_prefix}-instance"
  }
}
