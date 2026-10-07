# Security Group dla instancji EC2 (Bridge)
# Architektura Zero-Trust: BRAK reguł ingress (żaden port, w tym 22 SSH, nie jest otwarty z zewnątrz).
# Komunikacja odbywa się wyłącznie w tunelu wychodzącym zarządzanym przez AWS Systems Manager Agent.
resource "aws_security_group" "bridge_sg" {
  name        = "${var.name_prefix}-sg"
  description = "Zero-Trust SG dla instancji bridge - zero portow wejsciowych, zarzadzanie przez SSM"
  vpc_id      = var.vpc_id

  # Reguły wyjściowe (Egress):
  # 1. Port 443 (HTTPS) - niezbędny do komunikacji agenta SSM z endpointami AWS Systems Manager
  egress {
    description = "Wychodzacy ruch HTTPS dla AWS Systems Manager"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 2. Port bazy danych (np. 3306) - ruch do bazy danych RDS
  egress {
    description = "Wychodzacy ruch do bazy danych RDS"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 3. Opcjonalny ruch HTTP/HTTPS na repozytoria pakietów podczas startu (aktualizacje AL2023)
  egress {
    description = "Wychodzacy ruch HTTP do repozytoriow pakietow OS"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg"
  }
}

# Reguła Security Group dla istniejącego RDS
# Zezwala na ruch przychodzący na port bazy wyłącznie ze źródłowej grupy zabezpieczeń bridge
resource "aws_security_group_rule" "rds_ingress_from_bridge" {
  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  security_group_id        = var.rds_security_group_id
  source_security_group_id = aws_security_group.bridge_sg.id
  description              = "Zezwolenie na ruch z EC2 SSM bridge na port bazy danych"
}

