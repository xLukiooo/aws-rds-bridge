provider "aws" {
  region = var.aws_region
  profile = "default"
}

# Internet Gateway dla VPC (jeśli nie został jeszcze utworzony)
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "bridge-igw"
  }
}

# Nowy publiczny subnet w istniejącym VPC
resource "aws_subnet" "bridge_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.bridge_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "bridge-subnet"
  }
}

# Route Table dla publicznego subnetu
resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "bridge-public-rt"
  }
}

# Powiązanie Route Table z naszym subnetem
resource "aws_route_table_association" "bridge_assoc" {
  subnet_id      = aws_subnet.bridge_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group dla instancji bridge (EC2)
resource "aws_security_group" "bridge_sg" {
  name        = "bridge-sg"
  description = "Security Group dla instancji bridge (EC2)"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]   
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bridge-sg"
  }
}

# Tworzymy instancję EC2 (bridge) w celu łączenia się z RDS
resource "aws_instance" "bridge_ec2" {
  ami                    = var.bridge_ami
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.bridge_subnet.id
  vpc_security_group_ids = [aws_security_group.bridge_sg.id]
  key_name               = var.key_name

  root_block_device {
    volume_size = 8      
    volume_type = "gp3"  
  }
/*
  user_data = templatefile("${path.module}/bootstrap.sh", {
    db_engine = var.db_engine
  })
*/
  tags = {
    Name = "rds-bridge-instance"
  }
}

# Modyfikacja istniejącej Security Group RDS
# Dodajemy regułę, która pozwala na ruch z instancji bridge (SG) na port 3306
resource "aws_security_group_rule" "rds_ingress_from_bridge" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = var.rds_security_group_id
  source_security_group_id = aws_security_group.bridge_sg.id
  description              = "Allow bridge EC2 access to RDS"
}
