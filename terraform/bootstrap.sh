#!/bin/bash
if [ "${db_engine}" = "mysql" ]; then
  # Instalacja MySQL 
  amazon-linux-extras install -y mysql8.0
  systemctl enable mysqld
  systemctl start mysqld
else
  # Instalacja MariaDB
  sudo dnf install mariadb105
  systemctl enable mariadb
  systemctl start mariadb
fi
