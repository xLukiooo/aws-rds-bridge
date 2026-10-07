#!/bin/bash
# Skrypt startowy (user_data) dla Amazon Linux 2023 (x86_64)
# Instalacja narzędzi klienckich do opcjonalnej diagnostyki z poziomu powłoki SSM

dnf update -y
dnf install -y mariadb105 postgresql15

