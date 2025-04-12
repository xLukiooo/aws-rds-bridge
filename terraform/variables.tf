variable "aws_region" {
  description = "Region AWS, np. us-east-1"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID istniejącego VPC np. vpc-12345678"
  type        = string
  default     = "vpc-06396a3664c72af69" 
}

variable "bridge_subnet_cidr" {
  description = "CIDR dla nowego subnetu, np. 10.0.4.0/24"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone" {
  description = "Strefa dostępności, np. us-east-1a"
  type        = string
  default     = "us-east-1c"
}

variable "bridge_ami" {
  description = "AMI dla instancji bridge (np. Amazon Linux 2) np. ami-0abcdef1234567890"
  type        = string
  default     = "ami-00a929b66ed6e0de6"  
}

variable "key_name" {
  description = "Nazwa klucza SSH dla instancji EC2"
  type        = string
  default     = "bridge-key"  
}

variable "rds_security_group_id" {
  description = "ID security group dla RDS, którą należy zmodyfikować np. sg-12345678"
  type        = string
  default     = "sg-0d7cd9b6554693572" 
}

variable "db_engine" {
  description = "Wybór silnika bazy danych: mysql lub mariadb"
  type        = string
  default     = "mysql"
}


variable "my_ip" {
  description = "Mój adres IP do dostępu SSH, np. 123.123.123.123/32"
  type        = string
  default     = "81.162.210.154/32"  
}
