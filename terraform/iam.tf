# Rola IAM dla instancji EC2 umożliwiająca komunikację z AWS Systems Manager (SSM)
resource "aws_iam_role" "bridge_ssm_role" {
  name = "${var.name_prefix}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.name_prefix}-ssm-role"
  }
}

# Dołączenie oficjalnej polisy AWS SSM Managed Instance Core
resource "aws_iam_role_policy_attachment" "bridge_ssm_core" {
  role       = aws_iam_role.bridge_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Profil instancji przypisywany do zasobu aws_instance
resource "aws_iam_instance_profile" "bridge_profile" {
  name = "${var.name_prefix}-instance-profile"
  role = aws_iam_role.bridge_ssm_role.name

  tags = {
    Name = "${var.name_prefix}-instance-profile"
  }
}

