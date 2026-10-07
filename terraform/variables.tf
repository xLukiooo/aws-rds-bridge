variable "aws_region" {
  description = "Region AWS, np. us-east-1 lub eu-central-1"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Profil AWS CLI używany do uwierzytelnienia"
  type        = string
  default     = "default"
}

variable "environment" {
  description = "Środowisko wdrożeniowe (np. dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "name_prefix" {
  description = "Prefiks nazw dla tworzonych zasobów"
  type        = string
  default     = "rds-bridge"
}

variable "vpc_id" {
  description = "ID istniejącego VPC, w którym znajduje się baza danych RDS (np. vpc-12345678)"
  type        = string
}

variable "bridge_subnet_cidr" {
  description = "Blok CIDR dla podsieci instancji bridge (np. 10.0.100.0/24)"
  type        = string
  default     = "10.0.100.0/24"
}

variable "availability_zone" {
  description = "Strefa dostępności (AZ) dla podsieci bridge"
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "Typ instancji EC2 (architektura x86_64, np. t3.nano, t3.micro)"
  type        = string
  default     = "t3.micro"
}

variable "rds_security_group_id" {
  description = "ID Security Group powiązanej z bazą danych RDS, która zostanie zaktualizowana o zezwolenie na ruch z bridge"
  type        = string
}

variable "rds_endpoint" {
  description = "Endpoint (host DNS) bazy RDS do wygenerowania polecenia tunelu SSM (np. mydb.c123.us-east-1.rds.amazonaws.com)"
  type        = string
  default     = "<twoj-rds-endpoint>"
}

variable "db_port" {
  description = "Port bazy danych (np. 3306 dla MySQL/MariaDB, 5432 dla PostgreSQL)"
  type        = number
  default     = 3306
}

variable "local_port" {
  description = "Lokalny port na stacji roboczej, na który przekierowany zostanie ruch tunelu SSM"
  type        = number
  default     = 3306
}
